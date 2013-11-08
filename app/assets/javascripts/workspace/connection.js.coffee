((root) ->
  CodePal = root.CodePal = (root.CodePal || {})

  Connection = CodePal.Connection = {}

  getProjectId = Connection.getProjectId = ->
    return $('div#data').data("project-id")

  getStoredValues = Connection.getStoredValues = (callback) ->
    $.ajax
      url: '/api/projects/' + getProjectId() + '/project_files'
      type: 'get'
      success: (data, textStatus, xhr) ->
        CodePal.Editors.htmlBox.setValue(data[0].body, -1)
        CodePal.Editors.cssBox.setValue(data[1].body, -1)
        CodePal.Editors.renderOutput()
    callback()
   
  setupSaveButton = Connection.setupSaveButton = ->
    # add save to navbar
    saveButton = $('<button class="workspace-save" type="button">Save</button>')

    CodePal.Navbar.addOption(saveButton)

    saveButton.click ->
      $.ajax
        data:
          files:
            html: CodePal.Editors.htmlBox.getValue()
            css: CodePal.Editors.cssBox.getValue()
        dataType: 'json'
        url: '/api/projects/' + getProjectId() + '/project_files/save'
        type: 'post'
        success: (data, textStatus, xhr) ->
          CodePal.Lib.sendAlert("successfully saved", "success")
        error: (xhr, textStatus, errorThrown) ->
          CodePal.Lib.sendAlert("failed to save", "error")


  start = Connection.start = (getInitial)  ->
    # fill code boxes with the project file data
    # for now, I assume they come in order
    # this needs to be fixed somehow
    if !getInitial
      getStoredValues ->
        setupSaveButton()
    else
      setupSaveButton()
          
)(this)
