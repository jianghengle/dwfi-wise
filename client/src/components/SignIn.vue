<template>
  <div>
    <div class="welcome">
      Welcome! Please sign in to access the UNDA database.
    </div>

    <div class="field">
      <p class="control has-icons-left">
        <input class="input" type="text" placeholder="Email" v-model="email" @keyup.enter="login">
        <span class="icon is-small is-left">
          <icon name="envelope"></icon>
        </span>
      </p>
    </div>

    <div class="field">
      <p class="control has-icons-left">
        <input class="input" type="password" placeholder="Password" v-model="password" @keyup.enter="login">
        <span class="icon is-small is-left">
          <icon name="key"></icon>
        </span>
      </p>
    </div>

    <div class="field">
      <p class="control">
        <label class="checkbox">
          <input type="checkbox" v-model="rememberMe">
          Remember me
        </label>
      </p>
    </div>

    <div v-if="error" class="notification is-danger">
      <button class="delete" @click="error=''"></button>
      {{error}}
    </div>

    <div class="field">
      <p class="control">
        <button class="button is-link" :class="{'is-loading': waiting}" @click="login">Sign In</button>
      </p>
    </div>

    <div class="field">
      <router-link :to="'/sign_up'">Sign up a new account</router-link>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'sign-in',
  data () {
    return {
      email: '',
      password: '',
      rememberMe: false,
      error: '',
      waiting: false
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    }
  },
  methods: {
    login () {
      this.email = this.email.trim().toLowerCase()
      var message = {email: this.email, password: this.password}
      this.$http.post(xHTTPx + '/get_auth_token', message).then(response => {
        var resp = response.body
        var token = resp.token
        var email = resp.email
        var privileges = resp.privileges
        Vue.http.headers.common['Authorization'] = token
        this.$store.commit('user/setToken', token)
        this.$store.commit('user/setEmail', email)
        this.$store.commit('user/setPrivileges', privileges)
        if (this.rememberMe) {
          localStorage.setItem('token', token)
          localStorage.setItem('email', email)
          localStorage.setItem('privileges', privileges)
        }
        this.$router.push("/table/programs")
      }, response => {
        this.error = 'Failed to authorize user!'
        this.$store.commit('user/reset')
      })
    }
  },
  mounted () {
    if(this.token){
      this.$router.push('/table/programs')
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
