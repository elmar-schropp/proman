# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

allTasks = new Object();
myTasks = []
$tasks = null
taskId = null
# myProjektId = null
myProjektId = 2

window.isTouchDevice = 'ontouchstart' of document.documentElement;
if $(window).width() < 880
   window.isTouchDevice = true 


# alert("OK ???")
# $.cookie("viewMode", 11);
# alert($.cookie('viewMode'))


initTasks = ->
    $('#editor .nextbutton').click ->
        alert("brainstorm-modus --- coming soon")
    $('#editor .gotrash').click ->
        alert("ab in den papierkorb - coming soon")
    if (isTouchDevice)
        #$('body').css('background', '#ffffee');
        
        $('html').off('click.dropdown').off('touchstart.dropdown');
        
        # $('#editor').hide();
        editor_hide()
        $('#editor .cancelbutton').show().click ->
            editor_hide()
        $('body').addClass("is-touch");
    
    
    $('#editor').keydown (event) ->
        editor_onkeydown(event)
        # alert('Handler for .keydown() called.'  )
        # alert('Handler for .keydown() called.' + event.target )


$(window).on 'load', -> setTimeout initTasks, 1000





window.editor_onkeydown=(event) ->
    # alert ("xxx: editor_onkeydown"+event.target)


refreshTaskItem = (taskId)->
    id="#taskitem"+taskId
    # alert ("refreshTaskItem: "+id)
    # $(id).replaceWith("...ich werde mal der aktualisierte Inhalt ")
    

editor_show = ->
    #alert "show editor"
  
    $("#editor").show();
    $tasks.hide();
    if (isTouchDevice)
        $(".touch-only").hide();

editor_hide = ->
    # alert "HIDE editor"
    $("#editor").hide();
    $tasks.show();
    if (isTouchDevice)
        $(".touch-only").show();


$ ->
    $("#editor .save").click ->
        if ! taskId  then return
        $("#inputComment").css("backgroundColor", "#8cd36d")
        taskData= {
            titel : $("#inputTitle").val()
            kommentar  : $("#inputComment").val()
            tag        : $("#inputTags").val()
            priority   : $("#inputPriority").val()
            tasktype   : $("#inputTasktype").val()
            status     : $("#inputStatus").val()
            wichtig    : $("#inputWichtig").val()
            projekt_id : $("#inputProjekt_id").val()
            autor      : $("#inputAutor").val()
            autor2     : $("#inputAutor2").val()
            assigned_to: $("#inputAssigned_to").val()
        }
            
        $.ajax {
            url: "/tasks/" + taskId + ".json"
            data: {
                task: {
                    titel : $("#inputTitle").val()
                    kommentar  : $("#inputComment").val()
                    tag        : $("#inputTags").val()
                    priority   : $("#inputPriority").val()
                    tasktype   : $("#inputTasktype").val()
                    status     : $("#inputStatus").val()
                    wichtig    : $("#inputWichtig").val()
                    projekt_id : $("#inputProjekt_id").val()
                    autor      : $("#inputAutor").val()
                    autor2     : $("#inputAutor2").val()
                    assigned_to: $("#inputAssigned_to").val()
                }
            }
            success: (data) ->
                for row in allTasks[myProjektId]
                    # alert("-->"+row.id+"<-- "+row.titel)
                    # alert ("-->"+taskId+"<--")
                    if  parseInt(row.id) ==  parseInt(taskId) 
                        # alert ("TREFFER: "+row.id)
                        # alert(row["titel"])
                        # alert(taskData["titel"])
                        
                        row["titel"]=taskData["titel"]
                        row["kommentar"]=taskData["kommentar"]
                        row["priority"]=taskData["priority"]
                        row["status"]=taskData["status"]

                        # row=taskData    ..........warum geht der nicht ???
                        
                        
                refreshTaskItem taskId 
                # loadTasks
                displayTasks()
                
                $("#inputComment").css("backgroundColor", "#ffffff")
                if (isTouchDevice)
                    editor_hide()
                    # $("#editor").hide(); $tasks.show();
                    $('body').addClass("is-touch");
                    # alert("OK")
            dataType: "json"
            type: "PUT"
        }
        
    $tasks = $("table.tasks")
    if $tasks.size() > 0
        loadTasks












loadTasks = ->
    # alert(myProjektId)
    # alert(allTasks[myProjektId])
    if allTasks[myProjektId]
        myTasks = allTasks[myProjektId]
        displayTasks()
        return
    $.get "/tasks/list.json?projekt=" + myProjektId, (data) ->
        # alert(myProjektId)
        myTasks = data
        allTasks[myProjektId]=data
        displayTasks()
    , "json"


dynamicSort = `function(property) { 
    return function (obj1,obj2) {
        return obj1[property] < obj2[property] ? 1
            : obj1[property] > obj2[property] ? -1 : 0;
    }
}`

dynamicSortMultiple = `function() {
    /*
     * save the arguments object as it will be overwritten
     * note that arguments object is an array-like object
     * consisting of the names of the properties to sort by
     */
    var props = arguments;
    return function (obj1, obj2) {
        var i = 0, result = 0, numberOfProperties = props.length;
        /* try getting a different result from 0 (equal)
         * as long as we have extra properties to compare
         */
        while(result === 0 && i < numberOfProperties) {
            result = dynamicSort(props[i])(obj1, obj2);
            i++;
        }
        return result;
    }
}`

window.displayTasks = ->
    $tasks.html ""
    
    sortedTasks = myTasks.sort(dynamicSort("priority"))
    
    $tasks.append myTemplate.Header
    $tasks.append myTemplate.Template(_(row).extend(viewHelpers)) for row in sortedTasks
    
    $("table.tasks .task").click (e)->
        isSelected= $(this).hasClass "selected"
        # if !e.ctrlKey
            # $(".tasks .task.selected").removeClass "selected"
        
        if isTouchDevice
            if isSelected
                # alert e.screenX
                if (e.screenX < 200)  
                   editor_show()
                else
                    $(this).removeClass "selected"
            else
                # TEST  $(".tasks .task.selected").removeClass "selected"
                $(this).addClass "selected"
                $(this).after(getEditBar())

        else
            $(".tasks .task.selected").removeClass "selected"
            $(this).addClass "selected"
        
        taskId = $(this).attr "data-taskid"
        
        $.get("/tasks/" + taskId + ".json", (data) ->
            $("#inputTitle").val data.titel
            $("#inputComment").val data.kommentar
            $("#inputTags").val data.tag
            $("#inputPriority").val data.priority
            $("#inputTasktype").val data.tasktype  
            $("#inputStatus").val data.status
            $("#inputWichtig").val data.wichtig   
            $("#inputProjekt_id").val data.projekt_id   
            $("#inputAutor").val data.autor   
            $("#inputAutor2").val data.autor2   
            $("#inputAssigned_to").val data.assigned_to   
            
        , "json")
        
    .dblclick (e) ->
        window.location = "/tasks/" + $(this).attr("data-taskid") + "/edit"

wikitextUnarm = (t) ->
    t.replace(/([*_@!])/g, (ch) -> "&#" + ch.charCodeAt(0) + ";");

viewHelpers = {
    prepare_text : (text) ->
        _(text).escape()
        .replace(/{{{\s*([\s\S]*?)}}}/mg, (t) -> "<pre>" + wikitextUnarm(RegExp.$1) + "</pre>")
        .replace(/\[_\]/mg, '<input type=checkbox disabled>')
        .replace(/\[x\]/mg, '<input type=checkbox disabled checked>')
        .replace(/\*\*(.*?)\*\*/mg, '<b>$1</b>')
        .replace(/^\s*\*(.*)$/mg, '<li>$1</li>')
        .replace(/^(\s*)!(.*)$/mg, '$1<strong>$2</strong>')
        .replace(/___(.*?)___/mg, '<u>$1</u>')
        .replace(/@@(.*?)@@/mg, '<span class="label label-info">$1</span>')
        .replace(/\n/g, "<br>")
        .replace(/<\/li><br>/g, "</li>") #das muss auch irgendwie richtig gehen!
    priority_label : (prio) ->
        if prio < 100
            ""
        else if prio < 300
            "badge-info"
        else if prio < 500
            "badge-success"
        else if prio < 700
            "badge-warning"
        else if prio < 800
            "badge-important"
        else if prio < 1000
            "badge-inverse"
        else
            ""

}





template = {
maxi : {
    Header : ''
    Template : _.template('
  <tr class="maxitask task" data-taskid="<%= id %>" id="taskitem<%= id %>" >
    <td colspan="7" >
    <div class="head" style="border-top: 0px solid #cccccc; " >
        <span class="badge <%= priority_label(priority) %>"><%= priority %></span>
        <%= titel %>

        <a style="margin-top:-5px; "
        class="pull-right btn btn-small btn--success" href="/options"><i class="icon-star "></i></a>

    </div>
      <div class="comment"><%= prepare_text(kommentar)  %></div>
      <div class="tags"><i class="icon-tags"></i> <%= tag %></div>
      </td> 
 </tr>
  

  <tr  class="details"  style="background-color:#eeeeee;  border-top: 1px solid #cccccc; border-bottom: 1px solid #cccccc; " >
    <td><%= status %></td>
    <td><%= projekt_id %></td>
    <td><%= tasktype %></td>
    <td><%= wichtig %></td>
    <td><%= autor %></td>
    <td><%= autor2 %></td>
    <td><%= assigned_to %></td>
    
  </tr>
 <tr style="border-bottom: 0px solid #eeeeee;">
    <td colspan="8" >&nbsp;</td> 
 </tr>
 ')
}

midi : {
    Header : ''
    Template : _.template('
   <tr class="extraspace" style="border-bottom: 0px solid #eeeeee;">
    <td colspan="7" >  &nbsp;</td> 
   </tr>

  <tr class="miditask task" data-taskid="<%= id %>">
    <td colspan="7" >
    <div class="head" >
        <span class="badge <%= priority_label(priority) %>"><%= priority %></span>
       <%= titel %>
    </div>
      <div class="comment"   ><%= prepare_text(kommentar)  %></div>
      <div class="tags"      ><i class="icon-tags"></i> <%= tag %></div>
      </td> 
 </tr>
  

  <tr class="details" style="background-color:#eeeeee; border-top: 1px solid #cccccc; border-bottom: 1px solid #cccccc; " >
    <td><%= status %></td>
    <td><%= projekt_id %></td>
    <td><%= tasktype %></td>
    <td><%= wichtig %></td>
    <td><%= autor %></td>
    <td><%= autor2 %></td>
    <td><%= assigned_to %></td>
  </tr>


 ')
}

midi2 : {
    Header : ''
    Template : _.template('
   <tr class="extraspace" style="border-bottom: 0px solid #eeeeee;">
    <td colspan="8" >  &nbsp;</td> 
   </tr>

  <tr class="miditask task" data-taskid="<%= id %>">
    <td colspan="7" >
    <div class="head" >
        <span class="badge <%= priority_label(priority) %>"><%= priority %></span>
       <%= titel %>
         <a style="margin-top:-5px; "
        class="pull-right btn btn-small btn--success" href="/options"><i class="icon-star "></i></a>
    </div>
      <div class="comment"   ><%= prepare_text(kommentar)  %></div>
      <div class="tags"      ><i class="icon-tags"></i> <%= tag %></div>
      </td> 
 </tr>
  

  <tr class="details" style="background-color:#eeeeee; border-top: 1px solid #cccccc; border-bottom: 1px solid #cccccc; " >
    <td><%= status %></td>
    <td><%= projekt_id %></td>
    <td><%= tasktype %></td>
    <td><%= wichtig %></td>
    <td><%= autor %></td>
    <td><%= autor2 %></td>
    <td><%= assigned_to %></td>
  </tr>


 ')
}




mini: {
    Header: '<tr class="miniheader" data-taskid="<%= id %>">
    <th>Prio </th>
    <th>Titel / Kurzbeschreibung</th> 
    <th>Status </th>
    <th>Typ </th>
    <th>! ? </th>
    <th>Autor </th>
    <th>asg.to </th>
    
  </tr>'
    Template: _.template('
  <tr class="minitask task" data-taskid="<%= id %>">
    <td class="prio"><span class="badge <%= priority_label(priority) %>"><%= priority %></span></td>
    <td class="titel"><%= titel %> </td> 
    <td><%= status %></td>
    <td><%= tasktype %></td>
    <td><%= wichtig %></td>
    <td><%= autor %>/<%= autor2 %></td>
    <td><%= assigned_to %></td>
    
  </tr>
 ')
}
}

window.getEditBar = () ->
    template= '
    <br>
    <div id="in-place-edit-bar">
        <button class="btn btn-success"><i class="icon-white  icon-ok "></i> O K </button>
        <button class="btn "><i class="  icon-pencil "></i> edit</button>
        <button class="btn "><i class="  icon-star   "></i> Hit</button>
        <button class="btn "><i class="  icon-plus   "></i> More</button>
        <button class="btn btn-danger gotrash"><i class="icon-white icon-trash"></i></button>
      </div>'
    return template


# myTemplate = template.maxi
myTemplate = template.midi

window.setTaskTemplate = (templateId) ->
    myTemplate = template[templateId]
    
    displayTasks()

window.setTaskProjektFilter = (projektId) ->
    # alert  (projektId)
    myProjektId = projektId
    
    loadTasks()
