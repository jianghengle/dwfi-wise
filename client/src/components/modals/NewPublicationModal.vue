<template>
  <div class="modal"
      :class="{'is-active': opened}">
    <div class="modal-background"></div>
    <div class="modal-card">
      <header class="modal-card-head">
        <p class="modal-card-title">Create New Publication</p>
        <button class="delete" @click="close"></button>
      </header>
      <section class="modal-card-body">
        <div class="my-form">
          <div class="field">
            <label class="label">Title</label>
            <div class="control">
              <input class="input" type="text" v-model="title">
            </div>
          </div>

          <div class="field">
            <label class="label">Authors</label>
            <div class="control">
              <input class="input" type="text" v-model="authors">
            </div>
          </div>

          <div class="field">
            <label class="label">People</label>
            <div class="field is-grouped" v-for="(p, i) in people">
              <p class="select">
                <select class="long-select" v-model="p.people_id">
                  <option v-for="opt in allPeople" v-bind:value="opt.id">{{opt.label}}</option>
                </select>
              </p>&nbsp;&nbsp;&nbsp;
              <p class="control is-expanded">
                <input class="input" type="text" placeholder="Role" v-model="p.role">
              </p>
              <p class="control">
                <a class="button is-text" @click="removePeople(i)">
                  <icon name="remove"></icon>
                </a>
              </p>
            </div>
            <div class="field is-grouped">
              <div class="control">
                <button class="button" @click="addPeople"><icon name="plus"></icon>&nbsp;People</button>
              </div>
            </div>
          </div>

          <div class="field">
            <label class="label">Abstract</label>
            <div class="control">
              <textarea id="modal-textarea-description" class="textarea" v-model="abstract" @change="descriptionChanged"></textarea>
            </div>
          </div>

          <div class="field">
            <label class="label">Focus Area</label>
            <div class="field-body">
              <div class="field is-narrow">
                <div class="control">
                  <div class="selected-multiple-options">
                    {{focusAreaInput.join(', ')}}
                  </div>
                  <div class="select is-multiple is-fullwidth">
                    <select multiple v-model="focusAreaInput" size="7">
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

          <div class="field">
            <label class="label">Grants</label>
            <div class="field is-grouped" v-for="(g, i) in grants">
              <p class="select">
                <select class="long-select" v-model="g.grant_id">
                  <option v-for="opt in allGrants" v-bind:value="opt.id">{{opt.label}}</option>
                </select>
              </p>&nbsp;&nbsp;&nbsp;
              <p class="control is-expanded">
                <input class="input" type="text" placeholder="Comment" v-model="g.comment">
              </p>
              <p class="control">
                <a class="button is-text" @click="removeGrant(i)">
                  <icon name="remove"></icon>
                </a>
              </p>
            </div>
            <div class="field is-grouped">
              <div class="control">
                <button class="button" @click="addGrant"><icon name="plus"></icon>&nbsp;Grant</button>
              </div>
            </div>
          </div>

          <div class="field">
            <label class="label">Countries</label>
            <div class="field-body">
              <div class="field is-narrow">
                <div class="control">
                  <div class="selected-multiple-options">
                    {{countryInput.join(', ')}}
                    <a class="button is-text clear-country-button" @click="countryInput = []" v-if="countryInput.length">
                      <icon name="remove"></icon>
                    </a>
                  </div>
                  <div class="select is-multiple">
                    <select multiple v-model="countryInput" size="3">
                      <option v-for="c in countries">{{c}}</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="field">
            <label class="label">Status</label>
            <div class="field-body">
              <div class="field is-narrow">
                <div class="control">
                  <div class="select is-fullwidth">
                    <select v-model="status">
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

          <div class="field">
            <label class="label">Url</label>
            <div class="control">
              <input class="input" type="text" v-model="url">
            </div>
          </div>

          <div class="field">
            <label class="label">Point of Contact</label>
            <div class="field-body">
              <div class="field">
                <div class="control">
                  <div class="select">
                    <select v-model="pointOfContact">
                      <option v-for="opt in contactOptions" v-bind:value="opt.id">{{opt.label}}</option>
                    </select>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <div class="field">
            <label class="label">Files</label>
            <div class="field is-grouped" v-for="(f, i) in files">
              <p class="select">
                <select class="long-select" v-model="f.file_id">
                  <option v-for="opt in allFiles" v-bind:value="opt.id">{{opt.label}}</option>
                </select>
              </p>&nbsp;&nbsp;&nbsp;
              <p class="control is-expanded">
                <input class="input" type="text" placeholder="Comment" v-model="f.comment">
              </p>
              <p class="control">
                <a class="button is-text" @click="removeFile(i)">
                  <icon name="remove"></icon>
                </a>
              </p>
            </div>
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
  name: 'new-publication-modal',
  data () {
    return {
      waiting: false,
      error: '',
      success: '',
      allFiles: [],
      allPeople: [],
      allGrants: [],
      title: '',
      authors: '',
      people: [],
      abstract: '',
      focusArea: '',
      focusAreaInput: [],
      country: '',
      countryInput: [],
      url: '',
      status: '',
      pointOfContact: null,
      files: [],
      grants: [],
    }
  },
  computed: {
    opened () {
      return this.$store.state.modals.newPublicationModal.opened
    },
    source () {
      return this.$store.state.modals.newPublicationModal.source
    },
    key () {
      return this.$store.state.modals.newPublicationModal.key
    },
    countries () {
      return this.$store.state.table.countries
    },
    contactOptions () {
      var opts = this.allPeople.slice()
      opts.unshift({id: null, label: 'None'})
      return opts
    },
    canCreate () {
      return this.title
    },
  },
  watch: {
    opened: function (val) {
      if (val) {
        this.waiting = false
        this.error = ''
        this.success = ''
        this.title = ''
        this.authors = ''
        this.people = []
        this.abstract = ''
        this.focusArea = ''
        this.focusAreaInput = []
        this.country = ''
        this.countryInput = []
        this.url = ''
        this.status = ''
        this.pointOfContact = null
        this.files = []
        this.grants = []
        this.requestResources()
      }
    },
  },
  methods: {
    close(){
      var callback = this.$store.state.modals.newPublicationModal.callback
      if(callback){
        var method = callback.method
        var context = callback.context
        var args = callback.args
        method.apply(context, args)
      }
      this.$store.commit('modals/closeNewPublicationModal')
    },
    create(){
      if(!this.canCreate || this.waiting)
        return
      this.waiting = true

      var message = {
        source: this.source,
        key: this.key,
        title: this.title,
        authors: this.authors,
        abstract: this.abstract,
        focusArea: this.focusAreaInput.join(', '),
        country: this.countryInput.join(', '),
        status: this.status,
        url: this.url,
        pointOfContact: this.pointOfContact,
        files: JSON.stringify(this.files),
        people: JSON.stringify(this.people),
        grants: JSON.stringify(this.grants)
      }
      this.$http.post(xHTTPx + '/new_publication_by_requested', message).then(response => {
        this.error = ''
        this.success = 'Created!'
        this.waiting = false
      }, response => {
        this.error = 'Failed to create!'
        this.success = ''
        this.waiting = false
      })
    },
    requestResources () {
      this.$http.get(xHTTPx + '/get_people').then(response => {
        this.allPeople = response.body.map(function(p){
          return {id: p.id, label: p.firstName + ' ' + p.lastName + ' [' + p.id + ']'}
        }).sort(function(a, b){
          return a.label.localeCompare(b.label)
        })
      })
      this.$http.get(xHTTPx + '/get_files').then(response => {
        this.allFiles = response.body.map(function(f){
          return {id: f.id, label: f.name + ' [' + f.id + ']'}
        }).sort(function(a, b){
          return a.label.localeCompare(b.label)
        })
      })
      this.$http.get(xHTTPx + '/get_grants').then(response => {
        this.allGrants = response.body.map(function(g){
          return {id: g.id, label: g.organization + ' [' + g.id + ']'}
        }).sort(function(a, b){
          return a.label.localeCompare(b.label)
        })
      })
    },
    addPeople () {
      this.people.push({people_id: (this.allPeople.length ? this.allPeople[0].id : null), role: ''})
    },
    removePeople (idx) {
      this.people.splice(idx, 1)
    },
    addFile () {
      this.files.push({file_id: (this.allFiles.length ? this.allFiles[0].id : null), comment: ''})
    },
    removeFile (idx) {
      this.files.splice(idx, 1)
    },
    addGrant () {
      this.grants.push({grant_id: (this.allGrants.length ? this.allGrants[0].id : null), comment: ''})
    },
    removeGrant (idx) {
      this.grants.splice(idx, 1)
    },
    descriptionChanged () {
      var el = document.getElementById('modal-textarea-description');
      el.style.height = "1px";
      el.style.height = (25+el.scrollHeight)+"px";
    }
  },
}
</script>

<style lang="scss" scoped>
.my-form {
  margin-bottom: 10px;
}

.selected-multiple-options {
  margin-bottom: 0.375em;
}

.long-select {
  max-width: 400px;
}

.clear-country-button {
  height: 25px;
}
</style>