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
            <router-link v-for="t in basicTables" :key="'tl-'+t.name" class="navbar-item" :class="{'active-table': t == activeTable}" :to="t.path">
              {{t.label}}
            </router-link>

            <router-link v-for="t in otherTables" :key="'tl-'+t.name" class="navbar-item" :class="{'active-table': t == activeTable}" :to="t.path">
              {{t.label}}
            </router-link>

          </div>
          <div class="navbar-end" v-if="token">
            <a class="navbar-item" :href="staticUrl" target="_blank">
              <icon name="folder"></icon>
            </a>
            <router-link class="navbar-item" :class="{'active-table': routePath=='/users'}" :to="'/users'" v-if="privileges == 'Approve'">
              <icon name="users"></icon>
            </router-link>
            <router-link class="navbar-item" :class="{'active-table': routePath=='/change_password'}" :to="'/change_password'">
              <icon name="user"></icon>
            </router-link>
            <a class="navbar-item" @click="logout">
              <icon name="sign-out"></icon>
            </a>
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
        {name: 'publications', label: 'Publications', path: '/table/publications'},
        {name: 'faculty', label: 'Faculty', path: '/table/faculty'},
        {name: 'visiting_scholars', label: 'Scholars', path: '/table/visiting_scholars'},
      ],
      otherTables: [
        {name: 'people', label: 'People', path: '/table/people'},
        {name: 'grants', label: 'Grants', path: '/table/grants'},
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
    privileges () {
      return this.$store.state.user.privileges
    },
    routePath () {
      return this.$route.path
    },
    activeTable () {
      var routePath = this.routePath
      var table = null
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
    }else if(this.$route.name != 'Requested' && this.$route.name != 'RequestNewProject' && this.$route.name != 'RequestNewProgram'){
      this.$router.replace('/sign_in')
    }
  }
}
</script>

<style lang="scss" scoped>
.my-header {
  margin-bottom: 10px;
}

.active-table {
  color: hsl(217, 71%, 53%);
}
</style>
