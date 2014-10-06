#define app and dependencies
ToDoApp = angular.module("ToDoApp", ["ngRoute", "templates"])

#set up angular router
ToDoApp.config ["$routeProvider", "$locationProvider", ($routeProvider, $locationProvider) ->
  $routeProvider
    .when '/',
      templateUrl: "index.html",
      controller: "todosController"
    .otherwise
      redirectTo: "/"
    $locationProvider.html5Mode(true) #?
]


#todos controller
ToDoApp.controller "todosController", ["$scope", "$http", ($scope, $http) ->
  $scope.todos = []

  $scope.gettodos = ->
  # make a GET request to /todos.json
    $http.get("/todos.json").success (data) ->
      $scope.todos = data
      console.log(data)
      console.log($scope.todos)
  $scope.gettodos()

  #Create
  $scope.addToDo = ->   #addToDo linked to ng-submit
    $http.post("/todos.json", $scope.newToDo).success (data) -> #on submit posts into database, linked to controller. #? why not $scope.newToDo.thing
      $scope.newToDo = {} #newToDo linked to ng-model.. #? what is the point of this line? works without
      console.log($scope.newToDo)
      $scope.todos.push(data) #pushing into array above..

  #Delete
  $scope.deleteToDo = (todo) -> #linked to ng-click
    conf = confirm "Are you sure?"
    if conf
      $http.delete("/todos/#{todo.id}.json").success (data) -> #? isn't #{} syntax rails.. removing from database
        $scope.todos.splice($scope.todos.indexOf(todo),1) #removing from array above

  #Change completed status
  $scope.markCompleted = (todo) -> #linked to ng-change
    console.log todo.checked
    todo.completed = todo.completed == false ? true: false; #?
    todo.checked = todo.completed == false ? false: true;

    $http.put("/todos/#{todo.id}.json", todo).success (data) ->

    # OPEN EDITING FORM
  $scope.openForm = () ->
    this.editing = true   # if you did $scope.editing or $scope.viewing it will change each one not just the specific one clicked.
    this.viewing = true
  # EDIT
  $scope.editToDo = (todo) ->
    this.editing = false  #if you do $scope.editing, won't make editing box disappear
    this.viewing = false  # if you do $scope.viewing, won't show actual
    $http.put("/todos/#{todo.id}.json", todo).success (data) ->
]



# define Config for CSRF token
ToDoApp.config ["$httpProvider", ($httpProvider)->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
]