<template>
  <div>
    <h4 class="title is-4">
      <a class="button back-button" @click="$router.go(-1)">
        <icon name="chevron-left"></icon>
      </a>&nbsp;&nbsp;&nbsp;&nbsp;
      Grant {{grantId}}
    </h4>

    <div class="has-text-centered" v-if="waiting">
      <icon name="spinner" class="icon is-medium fa-spin"></icon>
    </div>

    <div v-if="error" class="notification is-danger">
      <button class="delete" @click="error=''"></button>
      {{error}}
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Organization</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="organization" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="privileges == 'Edit' || privileges == 'Approve'">
      <div class="field-label">
        <!-- Left empty for spacing -->
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button is-link" @click="update" :disabled="!changed" :class="{'is-loading': waiting}">Update</button>
          </div>
          <div class="control">
            <button class="button is-danger" @click="deleteSelf" :disabled="changed" :class="{'is-loading': waiting}">Delete</button>
          </div>
          <div class="control">
            <router-link class="button is-text" :to="'/table/grants'">Cancel</router-link>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: 'grant',
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      oldGrant: null,
      organization: '',
    }
  },
  computed: {
    privileges () {
      return this.$store.state.user.privileges
    },
    grantId () {
      return this.$route.params.id
    },
    changed () {
      var grant = this.collectGrant()
      if(JSON.stringify(grant) != JSON.stringify(this.oldGrant))
        return true
      return false
    }
  },
  methods: {
    collectGrant () {
      return {
        organization: this.organization,
      }
    },
    getGrant () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_grant/' + this.grantId).then(response => {
        var resp = response.body
        this.organization = resp.organization
        this.oldGrant = this.collectGrant()
        this.waiting = false
        this.error = ''
      }, response => {
        this.error = 'Failed to get grant!'
        this.waiting = false
      })
    },
    update () {
      var message = {
        organization: this.organization,
      }
      this.$http.post(xHTTPx + '/update_grant/' + this.grantId, message).then(response => {
        var resp = response.body
        this.success = 'Data updated successfully!'
        this.getGrant()
      }, response => {
        this.error = 'Failed to update grant!'
        this.waiting = false
      })
    },
    deleteSelf () {
      var confirm = {
        title: 'Delete Grant',
        message: 'Are you sure to delete the grant?',
        button: 'Yes, delete it.',
        callback: {
          context: this,
          method: this.deleteConfirmed,
          args: []
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    deleteConfirmed () {
      var message = {grantId: this.grantId}
      this.$http.post(xHTTPx + '/delete_grant', message).then(response => {
        if(response.body.ok){
          this.$router.replace('/table/grants')
        }
      }, response => {
        this.error = 'Failed to delete grant!'
        this.waiting = false
      })
    },
  },
  mounted () {
    this.getGrant()
  }
}
</script>

<style lang="scss" scoped>
.item-row {
  margin-bottom: 8px;
}
</style>
