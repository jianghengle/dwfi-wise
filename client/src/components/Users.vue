<template>
  <div>
    <div v-if="error" class="notification is-danger">
      <button class="delete" @click="error=''"></button>
      {{error}}
    </div>

    <table class="table is-hoverable is-fullwidth">
      <thead>
        <tr>
          <th>Total {{users.length}}</th>
          <th>Email</th>
          <th>Privileges</th>
          <th>Signed up at</th>
          <th>Delete</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="u, i in users" :key="u.id">
          <td>{{i+1}}</td>
          <td>{{u.email}}</td>
          <td>
            <div class="select">
              <select v-model="u.privileges" @change="userChanged(i)" :disabled="email==u.email">
                <option>None</option>
                <option>Read Only</option>
                <option>Edit</option>
                <option>Approve</option>
              </select>
            </div>
          </td>
          <td>{{u.registered}}</td>
          <td>
            <a class="button is-white" v-if="email!=u.email" @click="deleteUser(i)"><icon name="trash"></icon></a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
import DateForm from 'dateformat'

export default {
  name: 'users',
  data () {
    return {
      error: '',
      waiting: false,
      users: []
    }
  },
  computed: {
    email () {
      return this.$store.state.user.email
    },
  },
  methods: {
    getUsers () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_users').then((response) => {
        var resp = response.body
        var users = resp.map(function(u){
          var utcSeconds = u.createdTime
          var d = new Date(0)
          d.setUTCSeconds(utcSeconds)
          u.registered = DateForm(d, 'mmm dd yyyy h:MM TT')
          return u
        })
        users.sort(function(a, b){
          return b.createdTime - a.createdTime
        })
        this.users = users
        this.waiting = false
      }, (response) => {
        this.error = 'Failed to get all users: ' + JSON.stringify(response.body)
        this.waiting = false
      })
    },
    userChanged (i) {
      this.$http.post(xHTTPx + '/update_user', this.users[i]).then(response => {
        var ok = response.body && response.body.ok
        if(ok){
          this.success = true
          this.error = ''
        }else{
          this.success = false
          this.error = 'Failed to update user: ' + JSON.stringify(response.body)
        }
        this.waiting = false
      }, response => {
        this.success = false
        this.error = 'Failed to update user: ' + JSON.stringify(response.body)
        this.waiting = false
      })
    },
    deleteUser (i) {
      var confirm = {
        title: 'Delete User',
        message: 'Are you sure to delete the user: ' + this.users[i].email + '?',
        button: 'Yes, I am sure.',
        callback: {
          context: this,
          method: this.deleteConfirmed,
          args: [i]
        }
      }
      this.$store.commit('modals/openConfirmModal', confirm)
    },
    deleteConfirmed (i) {
      this.$http.post(xHTTPx + '/delete_user', this.users[i]).then(response => {
        if(response.body.ok){
          this.users.splice(i, 1)
        }
      }, response => {
        this.error = 'Failed to delete publication!'
        this.waiting = false
      })
    },
  },
  mounted () {
    this.getUsers()
  }
}
</script>

<style lang="scss" scoped>

td {
  vertical-align: middle;
  text-align: center;
}

th {
  text-align: center;
}

</style>
