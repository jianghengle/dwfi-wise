var tables = {
  programs: {
    label: 'Programs',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'title', type: 'str', label: 'Title'},
      {name: 'status', type: 'str', label: 'Status'},
      {name: 'startDate', type: 'time', label: 'Start Date'},
      {name: 'endDate', type: 'time', label: 'End Date'},
      {name: 'country', type: 'str', label: 'Country'},
      {name: 'isPublished', type: 'str', label: 'Is Published'}
    ],
    sort: {index: 0, asc: false},
    search: '',
    importOption: {
      columns: ['title', 'description', 'status', 'country', 'state', 'focusArea', 'startDate', 'endDate', 'funding', 'collaborators', 'moreInformation', 'pointOfContact', 'website', 'isPublished'],
      relations: {people: ['people_id', 'role'], publications: ['publication_id', 'comment'], files: ['file_id', 'comment'], grants: ['grant_id', 'comment']},
      notes: [
        'The <strong>startDate</strong> and <strong>endDate</strong> are in format of <strong>"Jan 01 2018"</strong> or empty.',
        'The <strong>pointOfContact</strong> is the people id from the people table',
        'The <strong>isPublished</strong> is <strong>true</strong> or <strong>false</strong>',
        'The <strong>people</strong>, <strong>publications</strong>, <strong>files</strong> and <strong>grants</strong> are items from the corresponding tables. Leave it empty if nothing. Otherwise, each item takes one line, while each line contains id and/or other information seperated by commas. For example:<pre>1\n2, director</pre>',
      ],
      url: '/create_program'
    },
    exportOption: {
      columns: ['id', 'title', 'description', 'status', 'country', 'state', 'focusArea', 'startDate', 'endDate', 'grants', 'funding', 'collaborators', 'moreInformation', 'pointOfContact', 'website', 'people', 'publications', 'files', 'isPublished'],
      relations: {grants: ['id', '/export_grants'], pointOfContact: ['pointOfContact', '/export_people_only'], people: ['id', '/export_people'], publications: ['id', '/export_publications'], files: ['id', '/export_files']},
    },
    deleteOption: {
      id: 'programId',
      url: '/delete_program'
    }
  },
  projects: {
    label: 'Projects',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'title', type: 'str', label: 'Title'},
      {name: 'status', type: 'str', label: 'Status'},
      {name: 'startDate', type: 'time', label: 'Start Date'},
      {name: 'endDate', type: 'time', label: 'End Date'},
      {name: 'country', type: 'str', label: 'Country'},
      {name: 'programId', type: 'int', label: 'Program Id'},
      {name: 'isPublished', type: 'str', label: 'Is Published'}
    ],
    sort: {index: 0, asc: false},
    search: '',
    importOption: {
      columns: ['title', 'description', 'status', 'country', 'state', 'focusArea', 'programId', 'startDate', 'endDate', 'funding', 'collaborators', 'moreInformation', 'pointOfContact', 'website', 'isPublished'],
      relations: {people: ['people_id', 'role'], publications: ['publication_id', 'comment'], files: ['file_id', 'comment'], grants: ['grant_id', 'comment']},
      notes: [
        'The <strong>startDate</strong> and <strong>endDate</strong> are in format of <strong>"Jan 01 2018"</strong> or empty.',
        'The <strong>programId</strong> is the program id from the programs table',
        'The <strong>pointOfContact</strong> is the people id from the people table',
        'The <strong>isPublished</strong> is <strong>true</strong> or <strong>false</strong>',
        'The <strong>people</strong>, <strong>publications</strong>, <strong>files</strong> and <strong>grants</strong> are items from the corresponding tables. Leave it empty if nothing. Otherwise, each item takes one line, while each line contains id and/or other information seperated by commas. For example:<pre>1\n2, director</pre>',
      ],
      url: '/create_project'
    },
    exportOption: {
      columns: ['id', 'title', 'description', 'status', 'country', 'state', 'focusArea', 'programId', 'startDate', 'endDate', 'grants', 'funding', 'collaborators', 'moreInformation', 'pointOfContact', 'website', 'people', 'publications', 'files', 'isPublished'],
      relations: {programId: ['programId', '/export_programs'], grants: ['id', '/export_grants'], pointOfContact: ['pointOfContact', '/export_people_only'], people: ['id', '/export_people'], publications: ['id', '/export_publications'], files: ['id', '/export_files']},
    },
    deleteOption: {
      id: 'projectId',
      url: '/delete_project'
    }
  },
  events: {
    label: 'Events',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'title', type: 'str', label: 'Title'},
      {name: 'status', type: 'str', label: 'Status'},
      {name: 'startDate', type: 'time', label: 'Start Date'},
      {name: 'endDate', type: 'time', label: 'End Date'},
      {name: 'country', type: 'str', label: 'Country'},
      {name: 'isPublished', type: 'str', label: 'Is Published'}
    ],
    sort: {index: 0, asc: false},
    search: '',
    importOption: {
      columns: ['title', 'description', 'status', 'country', 'state', 'focusArea', 'startDate', 'endDate', 'funding', 'collaborators', 'moreInformation', 'pointOfContact', 'website', 'isPublished'],
      relations: {people: ['people_id', 'role'], publications: ['publication_id', 'comment'], files: ['file_id', 'comment'], grants: ['grant_id', 'comment']},
      notes: [
        'The <strong>startDate</strong> and <strong>endDate</strong> are in format of <strong>"Jan 01 2018"</strong> or empty.',
        'The <strong>pointOfContact</strong> is the people id from the people table',
        'The <strong>isPublished</strong> is <strong>true</strong> or <strong>false</strong>',
        'The <strong>people</strong>, <strong>publications</strong>, <strong>files</strong> and <strong>grants</strong> are items from the corresponding tables. Leave it empty if nothing. Otherwise, each item takes one line, while each line contains id and/or other information seperated by commas. For example:<pre>1\n2, director</pre>',
      ],
      url: '/create_event'
    },
    exportOption: {
      columns: ['id', 'title', 'description', 'status', 'country', 'state', 'focusArea', 'startDate', 'endDate', 'grants', 'funding', 'collaborators', 'moreInformation', 'pointOfContact', 'website', 'people', 'publications', 'files', 'isPublished'],
      relations: {grants: ['id', '/export_grants'], pointOfContact: ['pointOfContact', '/export_people_only'], people: ['id', '/export_people'], publications: ['id', '/export_publications'], files: ['id', '/export_files']},
    },
    deleteOption: {
      id: 'eventId',
      url: '/delete_event'
    }
  },
  visiting_scholars: {
    label: 'Scholars',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'firstName', type: 'str', label: 'First Name'},
      {name: 'lastName', type: 'str', label: 'Last Name'},
      {name: 'status', type: 'str', label: 'Status'},
      {name: 'startDate', type: 'time', label: 'Start Date'},
      {name: 'endDate', type: 'time', label: 'End Date'},
      {name: 'programId', type: 'int', label: 'Program Id'},
      {name: 'isPublished', type: 'str', label: 'Is Published'}
    ],
    sort: {index: 0, asc: false},
    search: '',
    importOption: {
      columns: ['firstName', 'lastName', 'researchTopic', 'description', 'status', 'country', 'state', 'programId', 'focusArea', 'startDate', 'endDate', 'funding', 'collaborators', 'moreInformation', 'pointOfContact', 'isPublished'],
      relations: {people: ['people_id', 'role'], publications: ['publication_id', 'comment'], files: ['file_id', 'comment'], grants: ['grant_id', 'comment']},
      notes: [
        'The <strong>startDate</strong> and <strong>endDate</strong> are in format of <strong>"Jan 01 2018"</strong> or empty.',
        'The <strong>programId</strong> is the program id from the programs table',
        'The <strong>pointOfContact</strong> is the people id from the people table',
        'The <strong>isPublished</strong> is <strong>true</strong> or <strong>false</strong>',
        'The <strong>people</strong>, <strong>publications</strong>, <strong>files</strong> and <strong>grants</strong> are items from the corresponding tables. Leave it empty if nothing. Otherwise, each item takes one line, while each line contains id and/or other information seperated by commas. For example:<pre>1\n2, director</pre>',
      ],
      url: '/create_visiting_scholar'
    },
    exportOption: {
      columns: ['id', 'firstName', 'lastName', 'researchTopic', 'description', 'status', 'country', 'state', 'focusArea', 'startDate', 'endDate', 'funding', 'collaborators', 'moreInformation', 'pointOfContact', 'isPublished'],
      relations: {grants: ['id', '/export_grants'], pointOfContact: ['pointOfContact', '/export_people_only'], people: ['id', '/export_people'], publications: ['id', '/export_publications'], files: ['id', '/export_files']},
    },
    deleteOption: {
      id: 'visitingScholarId',
      url: '/delete_visiting_scholar'
    }
  },
  faculty: {
    label: 'Faculty',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'firstName', type: 'str', label: 'First Name'},
      {name: 'lastName', type: 'str', label: 'Last Name'},
      {name: 'yearJoined', type: 'int', label: 'Year Joined'},
      {name: 'status', type: 'str', label: 'Status'},
      {name: 'campus', type: 'str', label: 'Campus'}
    ],
    sort: {index: 0, asc: false},
    search: '',
    importOption: {
      columns: ['peopleId', 'yearJoined', 'status', 'campus', 'department', 'areaOfExpertise', 'expertiseTitle'],
      relations: {workPlans: ['year', 'plan']},
      notes: [
        'The <strong>peopleId</strong> is the people id from the people table',
        'The <strong>workPlans</strong> is the work plans of the faculty. Leave it empty if there is none. The work plan example is: <pre>2018\nPlan of 2018 paragraph one...\nPlan of 2018 Plan of 2018 paragraph two...\n2019\nPlan of 2019...</pre>',
      ],
      url: '/create_faculty'
    },
    exportOption: {
      columns: ['id', 'peopleId', 'yearJoined', 'status', 'campus', 'department', 'areaOfExpertise', 'expertiseTitle', 'workPlans'],
      relations: {peopleId: ['peopleId', '/export_people_only'], workPlans: ['id', '/export_work_plans']},
    },
    deleteOption: {
      id: 'facultyId',
      url: '/delete_faculty'
    }
  },
  people: {
    label: 'People',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'firstName', type: 'str', label: 'First Name'},
      {name: 'lastName', type: 'str', label: 'Last Name'},
      {name: 'title', type: 'str', label: 'Title'},
      {name: 'dwfiAffiliation', type: 'str', label: 'DWFI Affiliation'}
    ],
    sort: {index: 0, asc: false},
    search: '',
    importOption: {
      columns: ['firstName', 'lastName', 'credentials', 'title', 'employer', 'dwfiAffiliation', 'email', 'phone', 'website'],
      relations: {files: ['file_id', 'comment']},
      notes: [
        'The <strong>files</strong> are files from the files table. Leave it empty if nothing. Otherwise, each file takes one line, while each line contains id and/or other information seperated by commas. For example:<pre>1\n2, photo</pre>',
      ],
      url: '/create_people'
    },
    exportOption: {
      columns: ['id', 'firstName', 'lastName', 'credentials', 'title', 'employer', 'dwfiAffiliation', 'email', 'phone', 'website', 'files'],
      relations: {files: ['id', '/export_files']},
    },
    deleteOption: {
      id: 'peopleId',
      url: '/delete_people'
    }
  },
  publications: {
    label: 'Publications',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'title', type: 'str', label: 'Title'},
      {name: 'status', type: 'str', label: 'Status'},
      {name: 'country', type: 'str', label: 'Country'}
    ],
    sort: {index: 0, asc: false},
    search: '',
    importOption: {
      columns: ['title', 'authors', 'abstract', 'focusArea', 'country', 'status', 'url', 'pointOfContact', 'email', 'phone', 'website'],
      relations: {people: ['people_id', 'role'], grants: ['grant_id', 'comment'], files: ['file_id', 'comment']},
      notes: [
        'The <strong>pointOfContact</strong> is the people id from the people table',
        'The <strong>people</strong>, <strong>files</strong> and <strong>grants</strong> are items from the corresponding tables. Leave it empty if nothing. Otherwise, each item takes one line, while each line contains id and/or other information seperated by commas. For example:<pre>1\n2, first author</pre>',
      ],
      url: '/create_publication'
    },
    exportOption: {
      columns: ['id', 'title', 'people', 'abstract', 'focusArea', 'grants', 'country', 'status', 'url', 'pointOfContact', 'email', 'phone', 'website', 'files'],
      relations: {people: ['id', '/export_people'], grants: ['id', '/export_grants'], pointOfContact: ['pointOfContact', '/export_people_only'], files: ['id', '/export_files']},
    },
    deleteOption: {
      id: 'publicationId',
      url: '/delete_publication'
    }
  },
  files: {
    label: 'Files',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'name', type: 'str', label: 'Name'},
      {name: 'fileType', type: 'str', label: 'File Type'}
    ],
    sort: {index: 0, asc: false},
    search: '',
    importOption: {
      columns: ['name', 'fileType', 'url'],
      relations: {},
      notes: ['You only only import without uploading files'],
      url: '/create_file'
    },
    exportOption: {
      columns: ['id', 'name', 'fileType', 'url'],
      relations: {},
    },
    deleteOption: {
      id: 'fileId',
      url: '/delete_file'
    }
  },
  grants: {
    label: 'Grants',
    columns: [
      {name: 'id', type: 'int', label: 'Id'},
      {name: 'organization', type: 'str', label: 'Organization'},
      {name: 'comment', type: 'str', label: 'Order'}
    ],
    sort: {index: 0, asc: false},
    search: '',
    importOption: {
      columns: ['organization', 'comment'],
      relations: {},
      notes: [],
      url: '/create_grant'
    },
    exportOption: {
      columns: ['id', 'organization', 'comment'],
      relations: {},
    },
    deleteOption: {
      id: 'grantId',
      url: '/delete_grant'
    }
  }
}

var countries = ["Afghanistan", "Albania", "Algeria", "Angola", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bangladesh", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czech Republic", "Democratic Republic of the Congo", "Denmark", "Djibouti", "Dominican Republic", "East Timor", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands", "Fiji", "Finland", "France", "French Guiana", "French Southern and Antarctic Lands", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Greenland", "Guatemala", "Guinea", "Guinea Bissau", "Guyana", "Haiti", "Honduras", "Hungary", "Iceland", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Ivory Coast", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Lithuania", "Luxembourg", "Macedonia", "Madagascar", "Malawi", "Malaysia", "Mali", "Mauritania", "Mexico", "Moldova", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nepal", "Netherlands", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Korea", "Norway", "Oman", "Pakistan", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Puerto Rico", "Qatar", "Republic of Serbia", "Republic of the Congo", "Romania", "Russia", "Rwanda", "Saudi Arabia", "Senegal", "Sierra Leone", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland", "Syria", "Taiwan", "Tajikistan", "Thailand", "The Bahamas", "Togo", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United Republic of Tanzania", "United States of America", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "West Bank", "Western Sahara", "Yemen", "Zambia", "Zimbabwe"]
var states = ['Alabama','Alaska','American Samoa','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','District of Columbia','Federated States of Micronesia','Florida','Georgia','Guam','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine','Marshall Islands','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota','Northern Mariana Islands','Ohio','Oklahoma','Oregon','Palau','Pennsylvania','Puerto Rico','Rhode Island','South Carolina','South Dakota','Tennessee','Texas','Utah','Vermont','Virgin Island','Virginia','Washington','West Virginia','Wisconsin','Wyoming']

// initial state
export const state = {
  tables: tables,
  countries: countries,
  states: states
}

// mutations
export const mutations = {
  setSort (state, obj) {
    var sort = state.tables[obj.table].sort
    if(sort.index == obj.sort){
      sort.asc = !sort.asc
    }else{
      sort.index = obj.sort
    }
  },

  setSearch (state, obj) {
    state.tables[obj.table].search = obj.search.toLowerCase()
  }
}

export default {
  namespaced: true,
  state,
  mutations
}
