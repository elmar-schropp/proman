# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

myTasks = []
$tasks = null
taskId = null

window.isTouchDevice = 'ontouchstart' of document.documentElement;
# window.isTouchDevice = true

$ ->

    $("#editor .save").click ->
        if ! taskId  then return
        $("#inputComment").css("backgroundColor", "#8cd36d")
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
                $("#inputComment").css("backgroundColor", "#ffffff")
                if (isTouchDevice)
                    $("#editor").hide(); $tasks.show();
                    $('body').addClass("is-touch");
                # alert("OK")
            dataType: "json"
            type: "PUT"
        }
    
    $tasks = $("table.tasks")
    if $tasks.size() > 0
        $.get "/tasks.json", (data) ->
            myTasks = data
            displayTasks()
        , "json"

initTasks = ->
    $('#editor .nextbutton').click ->
        alert("brainstorm-modus --- coming soon")
    $('#editor .gotrash').click ->
        alert("ab in den papierkorb - coming soon")
    if (isTouchDevice)
        #$('body').css('background', '#ffeeff');
        $('html').off('click.dropdown').off('touchstart.dropdown');
        $('#editor').hide();
        $('#editor .cancelbutton').show().click ->
            $("#editor").hide(); $tasks.show();
        $('body').addClass("is-touch");

$(window).on 'load', -> setTimeout initTasks, 1000


window.displayTasks = ->
    $tasks.html ""
    $tasks.append myTemplate.Header
    $tasks.append myTemplate.Template(_(row).extend(viewHelpers)) for row in myTasks
    
    $("table.tasks .task").click (e)->
        if !e.ctrlKey
            $(".tasks .task.selected").removeClass "selected"
        
        if isTouchDevice
            $("#editor").show(); $tasks.hide();
        else
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
  <tr class="maxitask task" data-taskid="<%= id %>">
    <td colspan="7" >
    <div class="head">
        <%= titel %> <span class="pull-right badge <%= priority_label(priority) %>"><%= priority %></span>
    </div>
      <div class="comment"><%= prepare_text(kommentar)  %></div>
      <div class="tags"><i class="icon-tags"></i> <%= tag %></div>
      </td> 
 </tr>
  

  <tr style="background-color:#eeeeee;  border-top: 1px solid #cccccc; border-bottom: 1px solid #cccccc; " >
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

myTemplate = template.maxi

window.setTaskTemplate = (templateId) ->
    myTemplate = template[templateId]
    
    displayTasks()
