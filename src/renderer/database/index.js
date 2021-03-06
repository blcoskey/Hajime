import { join } from 'path'
import log from 'electron-log'
import Sequelize from 'sequelize'
import model_definition_list from './definitions'

const app = require('electron').remote.app
const TZ = "Etc/GMT-2" // TODO : Dynamique par rapport à la localisation du client ?

const isDevelopment = process.env.NODE_ENV !== 'production'
const isDebugBuild = process.env.ELECTRON_WEBPACK_IS_DEBUG_BUILD

log.transports.file.level = "info"

const debugLogger = (queryString, queryObject) => console.log(queryString, queryObject.bind)

const CreateSequelizeInstance = conf => {
    if (undefined === conf)
        throw new Error("[CreateSequelizeInstance] configuration is undefined")

    let options = {
        dialectOptions: { timezone: TZ }, // TODO : voir s'il faut pas laisser par défault la bdd faire comme il le fait par défaut... pour rendre l'application utilisable à différents endroits du globe
        timezone: TZ
    }

    if (conf.type === 'local')
    {
        conf.connection = {
            dialect: 'sqlite',
            storage: join(app.getPath("userData"), "db.sqlite")
        }
        options = {}
    }

    const sequelize = new Sequelize({
        ...conf.connection,
        ...options,
        define: {
            paranoid: true,
            underscored: true,
            freezeTableName: true,
            charset: 'utf8',
            dialectOptions: {
                charset: 'utf8',
                collate: 'utf8_general_ci'
            },
            timestamps: true
        },
        logging: (isDevelopment || isDebugBuild ? debugLogger : log.info)
    })

    let model_list = {}
    Object.keys(model_definition_list).forEach(modelName => { // Define all models
        const model_def = model_definition_list[modelName]

        const Model = sequelize.define(model_def.name, model_def.getDefinition(), { 
            tableName: model_def.name,
            ...model_def.options
        })
    
        if (undefined !== model_def.getAssociation)
            Model.associate = model_def.getAssociation(Model)

        model_list[model_def.name] = Model
    })

    Object.keys(model_list).forEach(modelName => { // Associate all models
        if (undefined !== model_list[modelName].associate)
            model_list[modelName].associate(model_list)
    })

    return { sequelize, model_list }
}

export { Sequelize, CreateSequelizeInstance }