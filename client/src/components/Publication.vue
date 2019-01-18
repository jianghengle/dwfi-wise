<template>
  <div>
    <h4 class="title is-4">
      <a class="button back-button" @click="$router.go(-1)">
        <icon name="chevron-left"></icon>
      </a>&nbsp;&nbsp;&nbsp;&nbsp;
      Publication {{publicationId}}
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
        <label class="label">Title</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="title" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Authors</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="authors" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(p, i) in people" v-if="p.people_id">
      <div class="field-label is-normal">
        <label class="label" v-if="i==firstPeople">People</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="p.people_id" :disabled="privileges == 'Read Only'">
              <option v-for="opt in allPeople" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Role" v-model="p.role" :disabled="privileges == 'Read Only'">
          </p>
          <p class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
            <a class="button is-text" @click="removePeople(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="privileges == 'Edit' || privileges == 'Approve'">
      <div class="field-label">
        <label class="label" v-if="firstPeople >= people.length">People</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addPeople"><icon name="plus"></icon>&nbsp;People</button>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Abstract</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <textarea id="textarea-description" class="textarea" v-model="abstract" @change="descriptionChanged" :disabled="privileges == 'Read Only'"></textarea>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Focus Area</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="selected-multiple-options">
              {{focusAreaInput.join(', ')}}
              <span class="icon is-small restore-icon" v-if="focusAreaInput.join(', ') != focusArea" @click="focusAreaInput = focusArea.split(', ')">
                <icon name="reply"></icon>
              </span>
            </div>
            <div class="select is-multiple is-fullwidth">
              <select multiple v-model="focusAreaInput" size="7" :disabled="privileges == 'Read Only'">
                <option>[FA1] Closing Water & Agricultural Productivity Gaps</option>
                <option>[FA2] Improving Groundwater Management for Agricultural Production</option>
                <option>[FA3] Enhancing High-productivity Irrigated Agriculture</option>
                <option>[FA4] Freshwater & Agriculture Ecosystems & Public Health</option>
                <option>[FA5] Management of Agricultural Drought</option>
                <option>Education & Engagement Projects & Programs</option>
                <option>Communications</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(g, i) in grants" v-if="g.grant_id">
      <div class="field-label is-normal">
        <label class="label" v-if="i==firstGrant">Grants</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="g.grant_id" :disabled="privileges == 'Read Only'">
              <option v-for="opt in allGrants" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Comment" v-model="g.comment" :disabled="privileges == 'Read Only'">
          </p>
          <p class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
            <a class="button is-text" @click="removeGrant(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="privileges == 'Edit' || privileges == 'Approve'">
      <div class="field-label">
        <label class="label" v-if="firstGrant >= grants.length">Grants</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addGrant"><icon name="plus"></icon>&nbsp;Grant</button>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Countries</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="selected-multiple-options">
              {{countryInput.join(', ')}}
              <span class="icon is-small restore-icon" v-if="countryInput.join(', ') != country" @click="countryInput = country ? country.split(', ') : []">
                <icon name="reply"></icon>
              </span>
              <span class="icon is-small restore-icon" v-if="countryInput.join(', ') == country && countryInput.length" @click="countryInput = []">
                <icon name="remove"></icon>
              </span>
            </div>
            <div class="select is-multiple" v-if="privileges == 'Edit' || privileges == 'Approve'">
              <select multiple v-model="countryInput" size="3">
                <option v-for="c in countries">{{c}}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Status</label>
      </div>
      <div class="field-body">
        <div class="field is-narrow">
          <div class="control">
            <div class="select is-fullwidth">
              <select v-model="status" :disabled="privileges == 'Read Only'">
                <option>In progress</option>
                <option>Under review</option>
                <option>Accepted</option>
                <option>Published</option>
                <option>Unknown - refer to point of contact</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Url</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="url" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Point of Contact</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="pointOfContact" :disabled="privileges == 'Read Only'">
                <option v-for="opt in contactOptions" v-bind:value="opt.id">{{opt.label}}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(f, i) in files" v-if="f.file_id">
      <div class="field-label is-normal">
        <label class="label" v-if="i==firstFile">Files</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="f.file_id" :disabled="privileges == 'Read Only'">
              <option v-for="opt in allFiles" v-bind:value="opt.id">{{opt.label}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <input class="input" type="text" placeholder="Comment" v-model="f.comment" :disabled="privileges == 'Read Only'">
          </p>
          <p class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
            <a class="button is-text" @click="removeFile(i)">
              <icon name="remove"></icon>
            </a>
          </p>
        </div>
      </div>
    </div>

    <div class="field is-horizontal" v-if="privileges == 'Edit' || privileges == 'Approve'">
      <div class="field-label">
        <label class="label" v-if="firstFile >= files.length">Files</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control">
            <button class="button" @click="addFile"><icon name="plus"></icon>&nbsp;File</button>
          </div>
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
            <router-link class="button is-text" :to="'/table/publications'">Cancel</router-link>
          </div>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import DateForm from 'dateformat'
import Datepicker from 'vuejs-datepicker'

export default {
  name: 'publication',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      oldPublication: null,
      oldFiles: null,
      oldPeople: null,
      oldGrants: null,
      allFiles: [],
      allPeople: [],
      allGrants: [],
      title: '',
      authors: '',
      people: [],
      abstract: '',
      focusArea: '',
      grants: [],
      focusAreaInput: [],
      country: '',
      countryInput: [],
      status: '',
      url: '',
      pointOfContact: '',
      files: [],
    }
  },
  computed: {
    privileges () {
      return this.$store.state.user.privileges
    },
    publicationId () {
      return this.$route.params.id
    },
    countries () {
      return this.$store.state.table.countries
    },
    firstPeople () {
      var i = 0
      while(i < this.people.length && (!this.people[i].people_id))
        i++
      return i
    },
    firstFile () {
      var i = 0
      while(i < this.files.length && (!this.files[i].file_id))
        i++
      return i
    },
    firstGrant () {
      var i = 0
      while(i < this.grants.length && (!this.grants[i].grant_id))
        i++
      return i
    },
    changed () {
      var publication = this.collectPublication()
      if(JSON.stringify(publication) != JSON.stringify(this.oldPublication))
        return true
      if(JSON.stringify(this.files) != JSON.stringify(this.oldFiles))
        return true
      if(JSON.stringify(this.people) != JSON.stringify(this.oldPeople))
        return true
      if(JSON.stringify(this.grants) != JSON.stringify(this.oldGrants))
        return true
      return false
    },
    changedPeople () {
      var changed = []
      for(var i=0;i<this.people.length;i++){
        var p = this.people[i]
        if(!p.people_id){
          changed.push(p)
        }else if(p.id){
          var old = this.oldPeople[i]
          if(p.people_id != old.people_id || p.role != old.role){
            changed.push(p)
          }
        }else{
          changed.push(p)
        }
      }
      return changed
    },
    changedFiles () {
      var changed = []
      for(var i=0;i<this.files.length;i++){
        var f = this.files[i]
        if(!f.file_id){
          changed.push(f)
        }else if(f.id){
          var old = this.oldFiles[i]
          if(f.file_id != old.file_id || f.comment != old.comment){
            changed.push(f)
          }
        }else{
          changed.push(f)
        }
      }
      return changed
    },
    changedGrants () {
      var changed = []
      for(var i=0;i<this.grants.length;i++){
        var g = this.grants[i]
        if(!g.grant_id){
          changed.push(g)
        }else if(g.id){
          var old = this.oldGrants[i]
          if(g.grant_id != old.grant_id || g.comment != old.comment){
            changed.push(g)
          }
        }else{
          changed.push(g)
        }
      }
      return changed
    },
    contactOptions () {
      var opts = this.allPeople.slice()
      opts.unshift({id: null, label: 'None'})
      return opts
    }
  },
  methods: {
    collectPublication () {
      return {
        title: this.title,
        authors: this.authors,
        abstract: this.abstract,
        focusArea: this.focusAreaInput.join(', '),
        country: this.countryInput.join(', '),
        status: this.status,
        url: this.url,
        pointOfContact: this.pointOfContact,
      }
    },
    getPublication () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_publication/' + this.publicationId).then(response => {
        var resp = response.body
        this.title = resp[0].title
        this.authors = resp[0].authors
        this.abstract = resp[0].abstract
        this.focusArea = resp[0].focusArea ? resp[0].focusArea : ''
        this.focusAreaInput = this.focusArea.split(', ')
        this.country = resp[0].country ? resp[0].country : ''
        this.countryInput = this.country ? this.country.split(', ') : []
        this.status = resp[0].status
        this.url = resp[0].url
        this.pointOfContact = resp[0].pointOfContact
        this.oldPublication = this.collectPublication()
        this.files = resp[1].map(function(f){
          return {id: f.id, file_id: f.fileId, comment: f.comment}
        })
        this.oldFiles = JSON.parse(JSON.stringify(this.files))
        this.people = resp[2].map(function(p){
          return {id: p.id, people_id: p.peopleId, role: p.role}
        })
        this.oldPeople = JSON.parse(JSON.stringify(this.people))
        this.grants = resp[3].map(function(g){
          return {id: g.id, grant_id: g.grantId, comment: g.comment}
        })
        this.oldGrants = JSON.parse(JSON.stringify(this.grants))
        this.waiting = false
        this.error = ''
        this.$nextTick(() => {
          this.descriptionChanged()
        })
      }, response => {
        this.error = 'Failed to get publication!'
        this.waiting = false
      })
    },
    requestResources () {
      this.$http.get(xHTTPx + '/get_people').then(response => {
        this.allPeople = response.body.map(function(p){
          return {id: p.id, label: p.firstName + ' ' + p.lastName + ' [' + p.id + ']'}
        })
      })
      this.$http.get(xHTTPx + '/get_files').then(response => {
        this.allFiles = response.body.map(function(f){
          return {id: f.id, label: f.name + ' [' + f.id + ']'}
        })
      })
      this.$http.get(xHTTPx + '/get_grants').then(response => {
        this.allGrants = response.body.map(function(g){
          return {id: g.id, label: g.organization + ' [' + g.id + ']'}
        })
      })
    },
    addPeople () {
      if(this.allPeople.length){
        this.people.push({people_id: this.allPeople[0].id, role: ''})
      }
    },
    removePeople (idx) {
      if(this.people[idx].id){
        this.people[idx].people_id = null
      }else{
        this.people.splice(idx, 1)
      }
    },
    addFile () {
      if(this.allFiles.length){
        this.files.push({file_id: this.allFiles[0].id, comment: ''})
      }
    },
    removeFile (idx) {
      if(this.files[idx].id){
        this.files[idx].file_id = null
      }else{
        this.files.splice(idx, 1)
      }
    },
    addGrant () {
      if(this.allGrants.length){
        this.grants.push({grant_id: this.allGrants[0].id, comment: ''})
      }
    },
    removeGrant (idx) {
      if(this.grants[idx].id){
        this.grants[idx].grant_id = null
      }else{
        this.grants.splice(idx, 1)
      }
    },
    update () {
      var message = {
        title: this.title,
        authors: this.authors,
        abstract: this.abstract,
        focusArea: this.focusAreaInput.join(', '),
        country: this.countryInput.join(', '),
        status: this.status,
        url: this.url,
        pointOfContact: this.pointOfContact,
        people: JSON.stringify(this.changedPeople),
        files: JSON.stringify(this.changedFiles),
        grants: JSON.stringify(this.changedGrants)
      }
      this.$http.post(xHTTPx + '/update_publication/' + this.publicationId, message).then(response => {
        var resp = response.body
        this.success = 'Data updated successfully!'
        this.getPublication()
      }, response => {
        this.error = 'Failed to update publication!'
        this.waiting = false
      })
    },
    deleteSelf () {
      var confirm = {
        title: 'Delete Publication',
        message: 'Are you sure to delete the publication?',
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
      var message = {publicationId: this.publicationId}
      this.$http.post(xHTTPx + '/delete_publication', message).then(response => {
        if(response.body.ok){
          this.$router.replace('/table/publications')
        }
      }, response => {
        this.error = 'Failed to delete publication!'
        this.waiting = false
      })
    },
    descriptionChanged () {
      var el = document.getElementById('textarea-description');
      el.style.height = "1px";
      el.style.height = (25+el.scrollHeight)+"px";
    }
  },
  mounted () {
    this.getPublication()
    this.requestResources()
  }
}
</script>

<style lang="scss" scoped>
.item-row {
  margin-bottom: 8px;
}

.selected-multiple-options {
  margin-top: 0.375em;
  margin-bottom: 0.375em;
}

.restore-icon {
  cursor: pointer;
  position: relative;
  top: 2px;
  left: 5px;
}
</style>
