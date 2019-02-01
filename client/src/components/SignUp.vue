<template>
  <div>
    <div class="welcome">
      Please complete the sign up form and click Submit.
    </div>

    <div class="field">
      <label class="label">Email</label>
      <div class="control has-icons-left">
        <input class="input" :class="{'is-danger': !emailValid}" type="text" placeholder="Email Address" v-model="email">
        <span class="icon is-small is-left">
          <icon name="envelope"></icon>
        </span>
      </div>
      <p v-if="!emailValid" class="help is-danger">Must be a valid email address</p>
    </div>

    <div class="field">
      <label class="label">Password</label>
      <div class="control has-icons-left">
        <input class="input" :class="{'is-danger': !passwordValid}" type="password" placeholder="Password" v-model="password">
        <span class="icon is-small is-left">
          <icon name="key"></icon>
        </span>
      </div>
      <p v-if="!passwordValid" class="help is-danger">Password must be at least 6 character.</p>
    </div>

    <div class="field">
      <label class="label">Confirm Password</label>
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
        <button class="button is-link" :class="{'is-loading': waiting}" :disabled="!canSubmit" @click="register">Submit</button>
      </p>
    </div>

    <div v-if="error" class="notification is-danger">
      <button class="delete" @click="error=''"></button>
      {{error}}
    </div>

    <div v-if="success" class="notification is-success">
      <button class="delete" @click="success=false"></button>
      You have successfully signed up. Please contact the system administrators to activate your account before you sign in.  
    </div>

    <div class="field">
      <router-link :to="'/sign_in'">Back to sign in</router-link>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'

const emailRegex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/

export default {
  name: 'sign-in',
  data () {
    return {
      email: '',
      password: '',
      passwordAgain: '',
      success: false,
      error: '',
      waiting: false
    }
  },
  computed: {
    emailValid () {
      return emailRegex.test(this.email)
    },
    passwordValid () {
      return this.password.length >= 6
    },
    passwordsMatch () {
      return this.password == this.passwordAgain
    },
    canSubmit () {
      return this.emailValid && this.passwordValid && this.passwordsMatch
    }
  },
  methods: {
    register () {
      if(!this.canSubmit)
        return
      this.waiting = true
      var message = {
        email: this.email,
        password: this.password
      }
      this.$http.post(xHTTPx + '/register', message).then(response => {
        var ok = response.body && response.body.ok
        if(ok){
          this.success = true
          this.error = ''
        }else{
          this.success = false
          this.error = 'Failed to register user: ' + JSON.stringify(response.body)
        }
        this.waiting = false
      }, response => {
        this.success = false
        this.error = 'Failed to register user: ' + JSON.stringify(response.body)
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
