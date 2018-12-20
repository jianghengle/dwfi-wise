<template>
  <div>
    <h4 class="title is-4">
      <a class="button back-button" @click="$router.go(-1)">
        <icon name="chevron-left"></icon>
      </a>&nbsp;&nbsp;&nbsp;&nbsp;
      Faculty {{peopleId}}
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
        <label class="label">People</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="peopleId" :disabled="privileges == 'Read Only'">
                <option v-for="opt in allPeople" v-bind:value="opt.id">{{opt.label}}</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Year Joined</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="yearJoined" :disabled="privileges == 'Read Only'">
                <option v-for="opt in yearOptions">{{opt}}</option>
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
        <div class="field">
          <div class="control">
            <div class="select">
              <select v-model="status" :disabled="privileges == 'Read Only'">
                <option>New</option>
                <option>Returning</option>
                <option>Not returning</option>
                <option>Retired</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Campus</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <div class="select" :disabled="privileges == 'Read Only'">
              <select v-model="campus">
                <option>UNL</option>
                <option>UNO</option>
                <option>UNK</option>
                <option>UNMC</option>
                <option>Other</option>
              </select>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Department</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="department" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Area of Expertise</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <textarea id="textarea-expertise" class="textarea" v-model="areaOfExpertise" :disabled="privileges == 'Read Only'" @change="textareaChanged('textarea-expertise')"></textarea>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label is-normal">
        <label class="label">Expertise Title</label>
      </div>
      <div class="field-body">
        <div class="field">
          <div class="control">
            <input class="input" type="text" v-model="expertiseTitle" :disabled="privileges == 'Read Only'">
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal">
      <div class="field-label">
        <label class="label">Work Plans</label>
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <div class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
            <button class="button" @click="addWorkPlan"><icon name="plus"></icon>&nbsp;Work Plan</button>
          </div>
        </div>
      </div>
    </div>

    <div class="field is-horizontal item-row" v-for="(w, i) in workPlans" v-if="w.faculty_id">
      <div class="field-label is-normal">
      </div>
      <div class="field-body">
        <div class="field is-grouped">
          <p class="select">
            <select v-model="w.year" :disabled="privileges == 'Read Only'">
              <option v-for="opt in yearOptions">{{opt}}</option>
            </select>
          </p>&nbsp;&nbsp;&nbsp;
          <p class="control is-expanded">
            <textarea :id="'textarea-work-plan-' + i" class="textarea" v-model="w.plan" :disabled="privileges == 'Read Only'" @change="textareaChanged('textarea-work-plan-' + i)"></textarea>
          </p>
          <p class="control" v-if="privileges == 'Edit' || privileges == 'Approve'">
            <a class="button is-text" @click="removeWorkPlan(i)">
              <icon name="remove"></icon>
            </a>
          </p>
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
            <router-link class="button is-text" :to="'/table/faculty'">Cancel</router-link>
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
  name: 'people',
  components: {
    Datepicker
  },
  data () {
    return {
      waiting: false,
      error: '',
      success: '',

      oldFaculty: null,
      oldWorkPlan: null,
      allPeople: [],

      peopleId: null,
      thisYear: null,
      yearOptions: [],
      yearJoined: null,
      status: 'New',
      campus: 'UNL',
      department: '',
      areaOfExpertise: '',
      expertiseTitle: '',

      workPlans: [],
    }
  },
  computed: {
    privileges () {
      return this.$store.state.user.privileges
    },
    facultyId () {
      return this.$route.params.id
    },
    firstWorkPlan () {
      var i = 0
      while(i < this.workPlans.length && (!this.workPlans[i].faculty_id))
        i++
      return i
    },
    changed () {
      var faculty = this.collectFaculty()
      if(JSON.stringify(faculty) != JSON.stringify(this.oldFaculty))
        return true
      if(JSON.stringify(this.workPlans) != JSON.stringify(this.oldWorkPlans))
        return true
      return false
    },
    changedWorkPlans () {
      var changed = []
      for(var i=0;i<this.workPlans.length;i++){
        var w = this.workPlans[i]
        if(!w.faculty_id){
          changed.push(w)
        }else if(w.id){
          var old = this.oldWorkPlans[i]
          if(w.year != old.year || w.plan != old.plan){
            changed.push(w)
          }
        }else{
          changed.push(w)
        }
      }
      return changed
    }
  },
  methods: {
    collectFaculty () {
      return {
        peopleId: this.peopleId,
        yearJoined: this.yearJoined,
        status: this.status,
        campus: this.campus,
        department: this.department,
        areaOfExpertise: this.areaOfExpertise,
        expertiseTitle: this.expertiseTitle,
      }
    },
    getFaculty () {
      this.waiting = true
      this.$http.get(xHTTPx + '/get_one_faculty/' + this.facultyId).then(response => {
        var resp = response.body
        this.peopleId = resp[0].peopleId
        this.yearJoined = resp[0].yearJoined
        this.status = resp[0].status
        this.campus = resp[0].campus
        this.department = resp[0].department
        this.areaOfExpertise = resp[0].areaOfExpertise
        this.expertiseTitle = resp[0].expertiseTitle
        this.oldFaculty = this.collectFaculty()
        this.workPlans = resp[1].map(function(w){
          return {id: w.id, faculty_id: w.facultyId, year: w.year, plan: w.plan}
        })
        this.workPlans.sort(function(a, b){
          return b.year - a.year 
        })
        this.oldWorkPlans = JSON.parse(JSON.stringify(this.workPlans))
        this.waiting = false
        this.error = ''
        this.$nextTick(function(){
          this.textareaChanged ('textarea-expertise')
          for(var i=0;i<this.workPlans.length;i++){
            this.textareaChanged ('textarea-work-plan-' + i)
          }
        })
      }, response => {
        this.error = 'Failed to get faculty!'
        this.waiting = false
      })
    },
    requestResources () {
      this.$http.get(xHTTPx + '/get_people').then(response => {
        this.allPeople = response.body.map(function(p){
          return {id: p.id, label: p.firstName + ' ' + p.lastName + ' [' + p.id + ']'}
        })
      })
    },
    addWorkPlan () {
      this.workPlans.unshift({faculty_id: this.facultyId, year: this.thisYear, plan: ''})
    },
    removeWorkPlan (idx) {
      if(this.workPlans[idx].id){
        this.workPlans[idx].faculty_id = null
      }else{
        this.workPlans.splice(idx, 1)
      }
    },
    update () {
      var message = {
        peopleId: this.peopleId,
        yearJoined: this.yearJoined,
        status: this.status,
        campus: this.campus,
        department: this.department,
        areaOfExpertise: this.areaOfExpertise,
        expertiseTitle: this.expertiseTitle,
        workPlans: JSON.stringify(this.workPlans)
      }
      this.$http.post(xHTTPx + '/update_faculty/' + this.facultyId, message).then(response => {
        var resp = response.body
        this.success = 'Data updated successfully!'
        this.getFaculty()
      }, response => {
        this.error = 'Failed to update faculty!'
        this.waiting = false
      })
    },
    deleteSelf () {
      var confirm = {
        title: 'Delete Faculty',
        message: 'Are you sure to delete the faculty?',
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
      var message = {facultyId: this.facultyId}
      this.$http.post(xHTTPx + '/delete_faculty', message).then(response => {
        if(response.body.ok){
          this.$router.replace('/table/faculty')
        }
      }, response => {
        this.error = 'Failed to delete faculty!'
        this.waiting = false
      })
    },
    textareaChanged (id) {
      var el = document.getElementById(id);
      el.style.height = "1px";
      el.style.height = (25+el.scrollHeight)+"px";
    }
  },
  mounted () {
    this.getFaculty()
    this.requestResources()
    var d = new Date()
    this.thisYear = d.getFullYear()
    this.yearJoined = this.thisYear
    for(var i=2015;i<=this.thisYear+5;i++){
      this.yearOptions.push(i)
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
