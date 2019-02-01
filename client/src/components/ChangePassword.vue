<template>
  <div>
    <div class="field">
      <label class="label">Email</label>
      <div class="control has-icons-left">
        <input class="input is-static" type="text" v-model="email">
        <span class="icon is-small is-left">
          <icon name="envelope"></icon>
        </span>
      </div>
    </div>

    <div class="field">
      <label class="label">New Password</label>
      <div class="control has-icons-left">
        <input class="input" :class="{'is-danger': !passwordValid}" type="password" placeholder="Password" v-model="password">
        <span class="icon is-small is-left">
          <icon name="key"></icon>
        </span>
      </div>
      <p v-if="!passwordValid" class="help is-danger">Password must be at least 6 character.</p>
    </div>

    <div class="field">
      <label class="label">Confirm New Password</label>
      <div class="control has-icons-left">
        <input class="input" :class="{'is-danger': !passwordsMatch}" type="password" placeholder="Retype Password" v-model="passwordAgain">
        <span class="icon is-small is-left">
          <icon name="key"></icon>
        </span>
      </div>
      <p v-if="!passwordsMatch" class="help is-danger">Retyped password must match the original one.</p>
    </div>

    <div class="field">
      <p class="control">
        <button class="button is-link" :class="{'is-loading': waiting}" :disabled="!canSubmit" @click="changePassword">Change Password</button>
      </p>
    </div>

    <div v-if="error" class="notification is-danger">
      <button class="delete" @click="error=''"></button>
      {{error}}
    </div>

    <div v-if="success" class="notification is-success">
      <button class="delete" @click="success=false"></button>
      You have successfully changed your password.  
    </div>

  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'change-password',
  data () {
    return {
      password: '',
      passwordAgain: '',
      success: false,
      error: '',
      waiting: false
    }
  },
  computed: {
    email () {
      return this.$store.state.user.email
    },
    passwordValid () {
      return this.password.length >= 6
    },
    passwordsMatch () {
      return this.password == this.passwordAgain
    },
    canSubmit () {
      return this.passwordValid && this.passwordsMatch
    }
  },
  methods: {
    changePassword () {
      if(!this.canSubmit)
        return
      this.waiting = true
      var message = {
        password: this.password
      }
      this.$http.post(xHTTPx + '/change_password', message).then(response => {
        var ok = response.body && response.body.ok
        if(ok){
          this.success = true
          this.error = ''
        }else{
          this.success = false
          this.error = 'Failed to change password: ' + JSON.stringify(response.body)
        }
        this.waiting = false
      }, response => {
        this.success = false
        this.error = 'Failed to change password: ' + JSON.stringify(response.body)
        this.waiting = false
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.welcome {
  margin-top: 20px;
  margin-bottom: 20px;
}

</style>
