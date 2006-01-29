// event.js: cross-browser Listener-style event handling
// version 0.9, 18-Apr-2001
// written by Andrew Clover <and@doxdesk.com>, use freely

event_list= new Array();

event_level= 0;
if (document.implementation)
  if (document.implementation.hasFeature('Events', '2.0'))
    event_level= 2;

function event_addListener(esource, etype, elistener) {
  var i;
  var alreadyTriggering= false;
  for (i= 0; i<event_list.length; i++) {
    if (event_list[i][0]==esource && event_list[i][1]==etype) {
      if (event_list[i][2]==elistener) return;
      alreadyTriggering= true;
  } }
  event_list[event_list.length]= new Array(esource, etype, elistener);
  if (!alreadyTriggering) {
    if (event_level==2) {
      if (esource==window && !(esource.addEventListener))
        esource= document; // Opera 7.2
      esource.addEventListener(etype, event_trigger_DOM2, false);
    } else {
      eval(event_trigger_DOM0(etype));
      esource['on'+etype]= event_trigger;
      if (esource.captureEvents)
        esource.captureEvents('Event.'+etype.toUpperCase());
  } }
}

function event_removeListener(esource, etype, elistener) {
  var i; var e;
  var j= 0;
  var removedListener= false;
  var keepTrigger= false;
  for (i= 0; i<event_list.length; i++) {
    if (event_list[i][0]==esource && event_list[i][1]==etype) {
      if (event_list[i][2]==elistener) {
        removedListener= true;
        continue;
      }
      else keepTrigger= true;
    }
    if (i!=j) event_list[j]= event_list[i];
    j++;
  }
  event_list.length= j;
  if (removedListener && !keepTrigger) {
    if (event_level==2)
      esource.removeEventListener(etype, elistener, true);
    else
      esource['on'+etype]= window.clientInformation ? null : window.undefined;
  }
}

function event_trigger_DOM2(e) {
  if (event_dispatch(e.target, e.type)==false)
    e.preventDefault();
}

function event_trigger_DOM0(t) {
  return 'function event_trigger() {return event_dispatch(this, \''+t+'\');}';
}

function event_dispatch(esource, etype) {
  var i; var r;
  var elisteners= new Array();
  var result= window.undefined;
  for (i= 0; i<event_list.length; i++)
    if (event_list[i][0]==esource && event_list[i][1]==etype)
      elisteners[elisteners.length]= event_list[i][2];
  for (i= 0; i<elisteners.length; i++) {
    r= elisteners[i](esource, etype);
    if (r+''!='undefined') result= r;
  }
  return result;
}

// convenience prevent-default-action listener
function event_prevent(esource, etype) { return false; }

// page finished loading detector for binding
var event_loaded= false;
function event_load(esource, etype) {
  event_loaded= true;
  event_removeListener(window, 'load', event_load);
}
event_addListener(window, 'load', event_load);

// binding helper
var event_BINDDELAY= 750;
var event_binds= new Array();

function event_addBinding(btag, blistener) {
  event_binds[event_binds.length]= new Array(btag, 0, blistener);
  if (event_intervalling)
    event_bind();
  else {
    event_intervalling= true;
    window.setTimeout(event_interval, 0);
  }
}

var event_intervalling= false;
function event_interval() {
  event_bind();
  if (!event_loaded)
    window.setTimeout(event_interval, event_BINDDELAY);
}

function event_bind() {
  var i, j, els, blistener;
  for (i= event_binds.length; i-->0;) {
    els= event_getElementsByTag(event_binds[i][0]);
    blistener= event_binds[i][2];
    for (j= event_binds[i][1]; j<els.length; j++)
      blistener(els[j]);
    event_binds[i][1]= event_getElementsByTag(event_binds[i][0]).length;
  }
}

// get elements by tag name with backup for pre-DOM browsers
var event_NIL= new Array();
function event_getElementsByTag(tag) {
  if (document.getElementsByTagName) {
    var arr= document.getElementsByTagName(tag);
    // IE5.0/Win doesn't support '*' for all tags
    if (tag!='*' || arr.length>0) return arr;
  }
  if (document.all) {
    if (tag=='*') return event_array(document.all);
    else return event_array(document.all.tags(tag));
  }
  tag= tag.toLowerCase();
  if (tag=='a') return event_array(document.links);
  if (tag=='img') return event_array(document.images);
  if (tag=='form') return event_array(document.forms);
  if (document.layers && tag=='div') return event_array(document.layers);
  return event_NIL;
}
function event_array(coll) {
  var arr= new Array(coll.length);
  for (var i= arr.length; i-->0;)
    arr[i]= coll[i];
  return arr;
}