# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

allTasks = new Object();
myTasks = []
$tasks = null
taskId = null
# myProjektId = null
# myProjektId = 2
myProjektId = $.cookie("CurPro")
# alert(myProjektId)
if not myProjektId then myProjektId=2
# alert(myProjektId)
 

window.isTouchDevice = 'ontouchstart' of document.documentElement;
if $(window).width() < 600
   window.isTouchDevice = true 

 # window.isTouchDevice = false




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
    
    curProject=myProjektId 
    # alert(curProject)
    setTaskProjektFilter(curProject)
    # alert("OK ???")
    # $.cookie("viewMode", 11);
    # alert($.cookie('viewMode'))
    # $.cookie("CurPro", 11);
    # alert($.cookie('viewMode'))

    
    
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
    # alert(taskId)
    $("#main-toolbar").addClass "hide-on-editor"
    $("#bookmark-toolbar").addClass "hide-on-editor"
    $("#editor").show();
    $tasks.hide();
    if (isTouchDevice)
        $(".touch-only").hide();

editor_hide = ->
    # alert "HIDE editor"
    $("#editor").hide();
    $("#main-toolbar").removeClass "hide-on-editor"
    $("#bookmark-toolbar").removeClass "hide-on-editor"
    $tasks.show();
    if (isTouchDevice)
        $(".touch-only").show();


$ ->
    $("#editor .save").click ->
        if ! taskId  then return
        if $("#inputProjekt_id").val() == "" 
            alert("kein Projekt zugewiesen") ;  return
             
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
    $tasks.append("<br><br>")
    $tasks.append myTemplate.Header
    $tasks.append myTemplate.Template(_(row).extend(viewHelpers)) for row in sortedTasks
    
    $("table.tasks .task").click (e)->
        taskId = $(this).attr "data-taskid"
        isSelected= $(this).hasClass "selected"
        # if !e.ctrlKey
            # $(".tasks .task.selected").removeClass "selected"
        
        if isTouchDevice
            if isSelected
                # alert e.screenX
                editor_show()
             else
                $(".tasks .task.selected").removeClass "selected"
                $("#in-place-edit-bar-0").remove()
                $("#in-place-edit-bar-1").remove()
                $("#in-place-edit-bar-2").remove()
                $("#in-place-edit-bar-3").remove()
                $("#in-place-edit-bar-4").remove()
            $(this).addClass "selected"
            # $(this).after(getEditBar(taskId))
            # alert(taskId)
            # alert($("#direktedit"+taskId)[0].id)
            $("#direktedit"+taskId).append(getEditBar(taskId))
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
    <td colspan="8" >
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


  <tr class="miditask task" data-taskid="<%= id %>">
     <td colspan="8" >
    <div class="head mybackground01" >
       <span class="badge <%= priority_label(priority) %>"><%= priority %></span>
       <span class="badge                pull-right "> <i class=" icon-white icon-star"></i> </span>
       <%= titel %>
    </div>
      <div class="comment"   ><%= prepare_text(kommentar)  %></div>
      <div class="tags"      ><i class="icon-tags"></i> <%= tag %></div>
  </td>
      
 </tr>
  

  <tr class="details" style="color:#ffffff; background-color:#888888;
        border-top: 1px solid #cccccc; border-bottom: 1px solid #cccccc; " >
    <td><%= status %></td>
    <td><%= projekt_id %></td>
    <td><%= tasktype %></td>
    <td><%= wichtig %></td>
    <td><%= autor %></td>
    <td><%= autor2 %></td>
    <td><%= assigned_to %></td>
   <td>xxx</td>
  </tr>
  <tr class="extraspace" id="direktedit<%= id %>" style="border-bottom: 0px solid #eeeeee;" >
       <td colspan="8" >
       </td> 
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
  

  <tr class="details" style="background:#aaaaaa; border-top: 1px solid #cccccc; border-bottom: 1px solid #cccccc; " >
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

window.getEditBar = (myTaskId) ->
    #alert(myTaskId)
    template= '

    <div id="in-place-edit-bar-1" style="min-width:360px; white-space:nowrap;  ">
        <button class="btn btn-success "><i class=" icon-white icon-ok ">         </i> O K </button>
        <a class="btn btn-inverse" href="http://proman.wikilab.de/tasks/new" target="_self" ">
            <i class="icon-white icon-plus"> </i></a>
        <button class="btn btn-inverse"><i class=" icon-white icon-star">        </i> </button>
        <button class="btn btn-inverse" onclick="alert(|||...coming soon|||)"><i class=" icon-arrow-down "> </i> Mehr </button>
        <button class="btn btn-inverse"><i class="icon-whiteicon-pencil ">   </i> edit </button>
         <a class="btn btn-danger" href="/tasks/'+myTaskId+'" data-confirm="'+myTaskId+'...Are you sure?" data-method="delete" rel="nofollow">
            <i class=" icon-white icon-white icon-trash"> </i></a>
    </div>
    <div id="in-place-edit-bar-2" style="min-width:360px; white-space:nowrap; " class="toolbar-plus hidden">
        <span class="badge">1</span>
        <button class="btn ">Heute</button>
        <button class="btn ">Morgen</button>
        <button class="btn ">diese Woche</button>
        <button class="btn ">naechste W.</button>
        <br>
        <button class="btn ">Vorgemerkt</button>
        <button class="btn ">Archiv</button>
        <button class="btn btn-danger gotrash">BUG</button>
    </div>
    <div id="in-place-edit-bar-3" style="min-width:370px;  white-space:nowrap; " class="toolbar-plus show">
        <span class="badge">2</span>
        <button class="btn ">NEXT</button>
        <button class="btn ">ruckZuck</button>
        <button class="btn ">Wichtig</button>
        <button class="btn ">Idee</button>
        <button class="btn "><i class=" icon-white icon-warning-sign">  </i></button>
        <br>
        <br>
   </div>
    <div id="in-place-edit-bar-4" style="min-width:360px; white-space:nowrap; "  class="toolbar-plus hidden"">
        <span class="badge">3</span>
        <button class="btn ">...prioritaeten</button>
    </div>'
    
    temp=replaceAll(template,"|||","'")
    # alert(temp)
    return temp
 


# myTemplate = template.maxi
myTemplate = template.midi

window.setTaskTemplate = (templateId) ->
    myTemplate = template[templateId]
    displayTasks()

window.setTaskProjektFilter = (projektId) ->
    # alert  (projektId)
    myProjektId = projektId
    # alert(myProjektId)
    $.cookie("CurPro", myProjektId,  { path: '/' })
    
    # alert ("SET: "+$.cookie("CurPro"))
    loadTasks()
