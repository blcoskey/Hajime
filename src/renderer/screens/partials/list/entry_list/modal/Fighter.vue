<script>
import { mapGetters } from 'vuex'
import { DateTime } from 'luxon'

const MODE_TYPE = {
    ADD: 'ADD',
    EDIT: 'EDIT'
}

const getFighterModel = () => ({
    is_present: false,
    is_favorite: false
})

export default {
    components: {},
    props: {
        id: {
            type: String,
            required: true
        },
        is_team: {
            type: Boolean,
            default: false,
        },
        team_option_list: {
            type: Array,
            default() { return [] }
        }
    },
    computed: {
        id_modal_filter() {
            return "modal-filter__"+this.id
        },
        form_is_valid() {
            return !Object.keys(this.fields).some(key => this.fields[key].invalid)
        },
        is_edit_mode() {
            return this.mode == MODE_TYPE.EDIT
        },
        modal_title() {
            return this.is_edit_mode ? this.$t('entry-list.action.editing') : this.$t('entry-list.action.adding')
        },
        is_empty_team_option_list() {
            return this.team_option_list.length === 0
        }
    },
    methods: {
        convertDate(date) {
            return DateTime.fromFormat(date, 'dd/MM/yyyy', { locale: 'fr' }).toSQLDate()
        },
        displayDate(date) {
            return DateTime.fromSQL(date).toFormat('dd/MM/yyyy', { locale: 'fr' })
        },
        show(fighter) {
            if (!!fighter) {
                this.mode = MODE_TYPE.EDIT
                this.is_new_team = false
                this.fighter = fighter

                this.fighter.birthdate = this.displayDate(this.fighter.birthdate)

                this.$nextTick().then(() => this.$validator.validateAll())
            } else
                this.is_new_team = this.team_option_list.length > 0 ? false : true

            this.$refs.modalFighter.show()
        },
        handleHide(event) {
            this.reset()
        },
        closeModal() {
            this.$refs.modalFighter.hide()
        },
        apply() {
            if (!this.form_is_valid)
                return

            this.fighter.birthdate = this.convertDate(this.fighter.birthdate)

            this.$emit('on-fighter-add', this.fighter)
            this.reset()
        },
        applyEditAndClose() {
            if (!this.form_is_valid)
                return

            this.fighter.birthdate = this.convertDate(this.fighter.birthdate)

            this.$emit('on-fighter-edit', this.fighter)
            this.closeModal()
        },
        applyAndClose() {
            this.apply()
            this.closeModal()
        },
        cancel() {
            this.closeModal()
        },
        reset() {
            this.mode = MODE_TYPE.ADD
            this.is_new_team = false
            this.fighter = getFighterModel()
            this.fighter.team_id = this.team_option_list.length > 0 ? this.team_option_list[0].id : null

            this.$nextTick().then(() => this.$validator.validateAll().then(() => this.errors.clear()))
        }
    },
    watch: {
        is_new_team: {
            handler(new_team) {
                if (!this.is_team)
                    return

                if (new_team)
                    this.fighter.team_id = null
                else if (!new_team && this.mode === MODE_TYPE.ADD)
                    this.fighter.team_id = this.team_option_list.length > 0 ? this.team_option_list[0].id : null
            },
            immediate: true
        }
    },
    data() {
        return {
            mode: MODE_TYPE.ADD,
            fighter: getFighterModel(),
            is_new_team: false
        }
    }
}
</script>

<i18n src="@lang/generic/common.json"></i18n>
<i18n src="@lang/screens/partials/list/entry.json"></i18n>

<template>
    <b-modal class="modal__fighter" :title="modal_title" size="lg" hide-header-close ref="modalFighter" @hide="handleHide">
        <div class="row">
            
            <div class="col-sm-6">
                <div class="form-group">
                    <div>
                        <label for="fighter__name">{{ $t('common.name') }} *</label>
                        <input
                            id="fighter__name"
                            class="form-control"
                            type="text"
                            name="name"

                            required

                            v-validate
                            v-model="fighter.name"

                            :class="{ 'is-invalid': errors.has('name') }"
                        >
                        <i class="form-group__bar"></i>
                    </div>
                    <span class="text-danger" v-if="errors.has('name')">{{ errors.first('name') }}</span>
                </div>
            </div>

            <div class="col-sm-6">
                <div class="form-group">
                    <div>
                        <label for="fighter__birthdate">{{ $t('common.date-birth') }} *</label>
                        <input
                            id="fighter__birthdate"
                            class="form-control"
                            type="text"
                            name="birthdate"
                            placeholder="Format JJ/MM/YYYY"

                            required

                            v-mask="'##/##/####'"
                            v-validate="{ date_format:'dd/MM/yyyy' }"
                            v-model="fighter.birthdate"

                            :class="{ 'is-invalid': errors.has('birthdate') }"
                        >
                        <i class="form-group__bar"></i>
                    </div>
                    <span class="text-danger" v-if="errors.has('birthdate')">{{ errors.first('birthdate') }}</span>
                </div>
            </div>

            <div class="col-sm-12">
                <div class="form-group">
                    <div>
                        <label for="fighter__license">{{ $t("common.of.number", { item: $t("common.license") }) | lowercase | capitalize({ onlyFirstLetter: true }) }} *</label>
                        <input
                            id="fighter__license"
                            class="form-control"
                            type="text"
                            name="license"

                            required

                            v-validate="{ max: 16 }"
                            v-model="fighter.license"

                            :class="{ 'is-invalid': errors.has('license') }"
                        >
                        <i class="form-group__bar"></i>
                    </div>
                    <span class="text-danger" v-if="errors.has('license')">{{ errors.first('license') }}</span>
                </div>
            </div>

            <div :class="{ 'col-sm-8': !is_edit_mode, 'col-sm-12': is_edit_mode }" v-if="is_team">
                <div class="form-group">
                    <div>
                        <label for="fighter__team">{{ $t('common.team') }} *</label>
                        <select
                            id="fighter__team"
                            class="form-control"
                            type="text"
                            name="team"

                            v-model="fighter.team_id"
                            v-if="!is_new_team"

                            :class="{ 'is-invalid': errors.has('team') }"
                        >
                            <option v-for="team in team_option_list" :value="team.id" :key="team.id">{{ team.name }}</option>
                        </select>

                        <input
                            id="fighter__team"
                            class="form-control"
                            type="text"
                            name="team"

                            required

                            v-validate
                            v-model="fighter.team_id"
                            v-else

                            :class="{ 'is-invalid': errors.has('team') }"
                        >
                        <i class="form-group__bar"></i>
                    </div>
                    <span class="text-danger" v-if="errors.has('team')">{{ errors.first('team') }}</span>
                </div>
            </div>

            <div class="col-sm-4" v-if="is_team && !is_edit_mode">
                <div class="form-group">
                    <label class="ml-2 custom-control custom-checkbox">
                        <input class="custom-control-input" v-model="is_new_team" type="checkbox" :disabled="is_empty_team_option_list">
                        <span class="custom-control-indicator"></span>
                        <span class="custom-control-description">{{ $t("common.team-new") }}</span>
                    </label>
                </div>
            </div>

            <div class="col-sm-6">
                <div class="form-group">
                    <div>
                        <label for="fighter__grade">{{ $t('common.grade') }}</label>
                        <input
                            id="fighter__grade"
                            class="form-control"
                            type="text"
                            name="grade"

                            v-validate
                            v-model="fighter.grade"

                            :class="{ 'is-invalid': errors.has('grade') }"
                        >
                        <i class="form-group__bar"></i>
                    </div>
                    <span class="text-danger" v-if="errors.has('grade')">{{ errors.first('grade') }}</span>
                </div>
            </div>

            <div class="col-sm-6">
                <div class="form-group">
                    <div>
                        <label for="fighter__club">{{ $t('common.club') }}</label>
                        <input
                            id="fighter__club"
                            class="form-control"
                            type="text"
                            name="club"

                            v-validate
                            v-model="fighter.club"

                            :class="{ 'is-invalid': errors.has('club') }"
                        >
                        <i class="form-group__bar"></i>
                    </div>
                    <span class="text-danger" v-if="errors.has('club')">{{ errors.first('club') }}</span>
                </div>
            </div>

        </div>

        <template slot="modal-footer">
            <div class="mr-auto">{{ $t("common.form.required") }}</div>

            <button type="button" class="btn btn-link" @click.prevent="cancel">{{ $t("common.action.cancel") }}</button>

            <template v-if="!is_edit_mode">
                <button type="button" class="btn" :disabled="!form_is_valid" :class="{'btn-outline-primary': form_is_valid}" @click.prevent="applyAndClose">{{ $t("common.action.add") }}</button>
                <button type="button" class="btn" :disabled="!form_is_valid" :class="{'btn-outline-primary': form_is_valid}" @click.prevent="apply">{{ $t("entry-list.action.add-enter") }}</button>
            </template>
            <template v-else>
                <button type="button" class="btn" :disabled="!form_is_valid" :class="{'btn-outline-primary': form_is_valid}" @click.prevent="applyEditAndClose">{{ $t("common.action.edit") }}</button>
            </template>
        </template>
    </b-modal>
</template>

<style lang="scss">
    .modal__fighter {
        .mx-input-append {
            color: #fff;
            background-color: transparent;

            svg {
                color: #fff;
            }
        }
    }
</style>
