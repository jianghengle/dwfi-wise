<template>
  <div>
    <h4 class="title is-4">
      New Grant
    </h4>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Organization</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="organization">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Comment</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="comment">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label">
        <!-- Left empty for spacing -->
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button is-link" @click="create">Create</button>
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
import DateForm from 'dateformat'

export default {
  name: 'new-grant',
  data () {
    return {
      waiting: false,
      error: '',
      organization: '',
      comment: ''
    }
  },
  methods: {
    create () {
      var message = {
        organization: this.organization,
        comment: this.comment
      }
      this.$http.post(xHTTPx + '/create_grant', message).then(response => {
        var resp = response.body
        this.waiting = false
        this.error = ''
        this.$router.push('/table/grants')
      }, response => {
        this.error = 'Failed to create grant!'
        this.waiting = false
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.item-row {
  margin-bottom: 8px;
}
</style>
