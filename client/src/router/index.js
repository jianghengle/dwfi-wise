import Vue from 'vue'
import Router from 'vue-router'
import SignIn from '@/components/SignIn'
import SignUp from '@/components/SignUp'
import ChangePassword from '@/components/ChangePassword'
import Users from '@/components/Users'
import TableIndex from '@/components/TableIndex'
import Program from '@/components/Program'
import NewProgram from '@/components/NewProgram'
import Project from '@/components/Project'
import NewProject from '@/components/NewProject'
import MyEvent from '@/components/MyEvent'
import NewEvent from '@/components/NewEvent'
import VisitingScholar from '@/components/VisitingScholar'
import NewVisitingScholar from '@/components/NewVisitingScholar'
import People from '@/components/People'
import NewPeople from '@/components/NewPeople'
import Faculty from '@/components/Faculty'
import NewFaculty from '@/components/NewFaculty'
import Publication from '@/components/Publication'
import NewPublication from '@/components/NewPublication'
import MyFile from '@/components/MyFile'
import NewFile from '@/components/NewFile'
import Grant from '@/components/Grant'
import NewGrant from '@/components/NewGrant'
import Requested from '@/components/Requested'
import RequestNewProgram from '@/components/RequestNewProgram'
import RequestNewProject from '@/components/RequestNewProject'
import Impact from '@/components/Impact'
import NewImpact from '@/components/NewImpact'
import Directory from '@/components/Directory'
import NewDirectory from '@/components/NewDirectory'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      redirect: '/sign_in'
    },
    {
      path: '/sign_in',
      name: 'SignIn',
      component: SignIn
    },
    {
      path: '/sign_up',
      name: 'SignUp',
      component: SignUp
    },
    {
      path: '/change_password',
      name: 'ChangePassword',
      component: ChangePassword
    },
    {
      path: '/users',
      name: 'Users',
      component: Users
    },
    {
      path: '/table/:tableName',
      name: 'TableIndex',
      component: TableIndex
    },
    {
      path: '/new/programs',
      name: 'NewProgram',
      component: NewProgram
    },
    {
      path: '/programs/:id',
      name: 'Program',
      component: Program
    },
    {
      path: '/new/projects',
      name: 'NewProject',
      component: NewProject
    },
    {
      path: '/projects/:id',
      name: 'Project',
      component: Project
    },
    {
      path: '/new/events',
      name: 'NewEvent',
      component: NewEvent
    },
    {
      path: '/events/:id',
      name: 'MyEvent',
      component: MyEvent
    },
    {
      path: '/new/visiting_scholars',
      name: 'NewVisitingScholar',
      component: NewVisitingScholar
    },
    {
      path: '/visiting_scholars/:id',
      name: 'VisitingScholar',
      component: VisitingScholar
    },
    {
      path: '/new/people',
      name: 'NewPeople',
      component: NewPeople
    },
    {
      path: '/people/:id',
      name: 'People',
      component: People
    },
    {
      path: '/new/faculty',
      name: 'NewFaculty',
      component: NewFaculty
    },
    {
      path: '/faculty/:id',
      name: 'Faculty',
      component: Faculty
    },
    {
      path: '/new/publications',
      name: 'NewPublication',
      component: NewPublication
    },
    {
      path: '/publications/:id',
      name: 'Publication',
      component: Publication
    },
    {
      path: '/files/:id',
      name: 'MyFile',
      component: MyFile
    },
    {
      path: '/new/files',
      name: 'NewFile',
      component: NewFile
    },
    {
      path: '/grants/:id',
      name: 'Grant',
      component: Grant
    },
    {
      path: '/new/grants',
      name: 'NewGrant',
      component: NewGrant
    },
    {
      path: '/requested/:thing/:key',
      name: 'Requested',
      component: Requested
    },
    {
      path: '/request_new_program/:thing/:key',
      name: 'RequestNewProgram',
      component: RequestNewProgram
    },
    {
      path: '/request_new_project/:thing/:key',
      name: 'RequestNewProject',
      component: RequestNewProject
    },
    {
      path: '/impacts/:id',
      name: 'Impact',
      component: Impact
    },
    {
      path: '/new/impacts',
      name: 'NewImpact',
      component: NewImpact
    },
    {
      path: '/new/directories',
      name: 'NewDirectory',
      component: NewDirectory
    },
    {
      path: '/directories/:id',
      name: 'Directory',
      component: Directory
    },
  ]
})
