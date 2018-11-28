<template>
  <div class="my-header">
    <nav class="navbar has-shadow is-fixed-top">
      <div class="container">
        <div class="navbar-brand">
          <router-link class="navbar-item is-size-4 has-text-weight-bold has-text-black" :to="'/'">
            UNDA
          </router-link>
          <div class="navbar-burger burger app-burger" :class="{'is-active': menuActive && token}"
            v-if="token"
            @click="menuActive = !menuActive">
            <span></span>
            <span></span>
            <span></span>
          </div>
        </div>
        <div class="navbar-menu" :class="{'is-active': menuActive && token}">
          <div class="navbar-start" v-if="token">
            <div class="navbar-item has-dropdown is-hoverable">
              <router-link class="navbar-link" :to="activeTable.path">
                {{activeTable.label}}
              </router-link>
              <div class="navbar-dropdown is-boxed">
                <router-link v-for="t in basicTables" :key="'tl-'+t.name" class="navbar-item" :class="{'is-active': t == activeTable}" :to="t.path">
                  {{t.label}}
                </router-link>
                <hr class="dropdown-divider">
                <router-link v-for="t in otherTables" :key="'tl-'+t.name" class="navbar-item" :class="{'is-active': t == activeTable}" :to="t.path">
                  {{t.label}}
                </router-link>
                <hr class="dropdown-divider">
                <a class="navbar-item" :href="staticUrl" target="_blank">List Static Files</a>
            </div>
            </div>
          </div>
          <div class="navbar-end" v-if="token">
            <a class="navbar-item">
              Signed in as {{email}}
            </a>
              
            <div class="navbar-item">
              <div class="field is-grouped">
                <p class="control">
                  <a class="button" @click="logout">
                    <icon name="sign-out"></icon>
                    Sign Out
                  </a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </nav>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'my-header',
  data () {
    return {
      menuActive: false,
      basicTables: [
        {name: 'programs', label: 'Programs', path: '/table/programs'},
        {name: 'projects', label: 'Projects', path: '/table/projects'},
        {name: 'events', label: 'Events', path: '/table/events'},
        {name: 'visiting_scholars', label: 'Scholars', path: '/table/visiting_scholars'},
      ],
      otherTables: [
        {name: 'people', label: 'People', path: '/table/people'},
        {name: 'grants', label: 'Grants', path: '/table/grants'},
        {name: 'publications', label: 'Publications', path: '/table/publications'},
        {name: 'files', label: 'Files', path: '/table/files'},
      ],
      staticUrl: xHTTPx + '/dwfi_wise_files'
    }
  },
  computed: {
    token () {
      return this.$store.state.user.token
    },
    email () {
      return this.$store.state.user.email
    },
    routePath () {
      return this.$route.path
    },
    activeTable () {
      var routePath = this.routePath
      var table = {}
      this.basicTables.forEach(function(t){
        if(routePath.indexOf(t.name) != -1){
          table = t
        }
      })
      this.otherTables.forEach(function(t){
        if(routePath.indexOf(t.name) != -1){
          table = t
        }
      })
      return table
    }
  },
  methods: {
    logout () {
      delete Vue.http.headers.common['Authorization']
      this.$store.commit('user/reset')
      this.$router.push('/sign_in')
    }
  },
  mounted () {
    if(this.token){
      Vue.http.headers.common['Authorization'] = this.token
    }else{
      this.$router.replace('/sign_in')
    }
  }
}
</script>

<style lang="scss" scoped>
.my-header {
  margin-bottom: 10px;
}
</style>
