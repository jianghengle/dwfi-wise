<template>
  <div class="modal"
      :class="{'is-active': opened}">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Create New Grant</p>
        <button class="delete" @click="close"></button>
      </header>
      <section class="modal-card-body">
        <div class="my-form">
          <div class="field">
            <label class="label">Organization</label>
            <div class="control">
              <input class="input" type="text" v-model="organization">
            </div>
          </div>

          <div class="field">
            <label class="label">Order</label>
            <div class="control">
              <input class="input" type="text" v-model="comment">
            </div>
          </div>
        </div>

        <div v-if="error" class="notification is-danger">
          <button class="delete" @click="error=''"></button>
          {{error}}
        </div>

        <div v-if="success" class="notification is-success">
          <button class="delete" @click="success=''"></button>
          {{success}} 
        </div>

      </section>
      <footer class="modal-card-foot">
        <a class="button is-danger" :disabled="!canCreate" @click="create" :is-loading="waiting">Create</a>
        <a class="button" @click="close">Close</a>
      </footer>
    </div>
  </div>
</template>

<script>
export default {
  name: 'new-grant-modal',
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      organization: '',
      comment: ''
    }
  },
  computed: {
    opened () {
      return this.$store.state.modals.newGrantModal.opened
    },
    source () {
      return this.$store.state.modals.newGrantModal.source
    },
    key () {
      return this.$store.state.modals.newGrantModal.key
    },
    canCreate () {
      return this.organization
    }
  },
  watch: {
    opened: function (val) {
      if (val) {
        this.waiting = false
        this.error = ''
        this.success = ''
        this.organization = ''
        this.comment = ''
      }
    },
  },
  methods: {
    close(){
      var callback = this.$store.state.modals.newGrantModal.callback
      if(callback){
        var method = callback.method
        var context = callback.context
        var args = callback.args
        method.apply(context, args)
      }
      this.$store.commit('modals/closeNewGrantModal')
    },
    create(){
      this.waiting = true

      var message = {
        source: this.source,
        key: this.key,
        organization: this.organization,
        comment: this.comment
      }
      this.$http.post(xHTTPx + '/new_grant_by_requested', message).then(response => {
        this.error = ''
        this.success = 'Created!'
        this.waiting = false
      }, response => {
        this.error = 'Failed to create!'
        this.success = ''
        this.waiting = false
      })
    }
  },
}
</script>

<style lang="scss" scoped>
.my-form {
  margin-bottom: 10px;
}
</style>