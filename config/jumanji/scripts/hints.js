// hint_letter_seq = 'FDSARTGBVECWXQYIOPMNHZULKJ';
hint_letter_seq = 'auie,ctsrn';
hint_font_size = '12px';
hint_font_weight = 'normal';
hint_font_family = 'Inconsolata';
hint_style = 'letter';
hint_fg_color = '#ffffff';
hint_bg_color = '#000088';
hint_active_color = '#00ff00';
hint_normal_color = '#ffff99';
hint_border = '2px dashed #000000';
hint_opacity = 0.750000;
var elements = [];
var active_arr = [];
var hints;
var overlays;
var active;
var last_active;
var lastpos = 0;
var lastinput;
var hint_types = 'a, area, textarea, select, link, input:not([type=hidden]), button,  frame, iframe, *[onclick], *[onmousedown], *[role=link], *[onmouseup], *[onmouseover] *[oncommand]';

var styles = null;

function JumanjiHint(element, offset) {
  this.element = element;
  this.rect = element.getBoundingClientRect();
  if (!offset) {
    offset = [ 0, 0 ];
  }

  function create_span(element) {
    var span = document.createElement("span");
    if (offset) {
      var leftpos = offset[0] + Math.max((element.rect.left + document.defaultView.scrollX), document.defaultView.scrollX) ;
      var toppos = offset[1] + Math.max((element.rect.top + document.defaultView.scrollY), document.defaultView.scrollY) ;
    }
    span.style.position = "absolute";
    span.style.left = leftpos  + "px";
    span.style.top = toppos + "px";
    return span;
  }

  function create_hint(element) {
    var hint = create_span(element);
    hint.style.fontSize = hint_font_size;
    hint.style.fontWeight = hint_font_weight;
    hint.style.fontFamily = hint_font_family;
    hint.style.color = hint_fg_color;
    hint.style.background = hint_bg_color;
    hint.style.opacity = hint_opacity;
    hint.style.border = hint_border;
    hint.style.zIndex = 20000;
    hint.style.visibility = 'visible';
    hint.name = "jumanji_hint";
    return hint;
  }

  this.hint = create_hint(this);
}
//JumanjiNumberHint
JumanjiNumberHint.prototype.getTextHint = function (i, length) {
  start = length <=10 ? 1 : length <= 100 ? 10 : 100;
  var content = document.createTextNode(start + i);
  this.hint.appendChild(content);
};

JumanjiNumberHint.prototype.betterMatch = function(input) {
  var bestposition = 37;
  var ret = 0;
  for (var i=0; i<active_arr.length; i++) {
    var e = active_arr[i];
    if (input && bestposition !== 0) {
      var content = e.element.textContent.toLowerCase().split(" ");
      for (var cl=0; cl<content.length; cl++) {
        if (content[cl].toLowerCase().indexOf(input) === 0) {
          if (cl < bestposition) {
            ret = i;
            bestposition = cl;
            break;
          }
        }
      }
    }
  }
  return ret;
};

JumanjiNumberHint.prototype.matchText = function(input) {
  var ret = false;
  if (parseInt(input, 10) == input) {
    text_content = this.hint.textContent;
  }
  else {
    text_content = this.element.textContent.toLowerCase();
  }
  if (text_content.match(input)) {
    return true;
  }
};

// JumanjiLetterHint
JumanjiLetterHint.prototype.getTextHint = function(i, length) {
  var text;
  var l = hint_letter_seq.length;
  if (length < l) {
    text = hint_letter_seq[i];
  }
  else if (length < 2*l) {
    var rem = (length) % l;
    var sqrt = Math.sqrt(2*rem);
    var r = sqrt == (getint = parseInt(sqrt, 10)) ? sqrt + 1 : getint;
    if (i < l-r) {
      text = hint_letter_seq[i];
    }
    else {
      var newrem = i%(r*r);
      text = hint_letter_seq[Math.floor( (newrem / r) + l - r )] + hint_letter_seq[l-newrem%r - 1];
    }
  }
  else {
    text = hint_letter_seq[i%l] + hint_letter_seq[l - 1 - (parseInt(i/l, 10))];
  }
  var content = document.createTextNode(text);
  this.hint.appendChild(content);
};

JumanjiLetterHint.prototype.betterMatch = function(input) {
  return 0;
};

JumanjiLetterHint.prototype.matchText = function(input) {
  return (this.hint.textContent.toLowerCase().indexOf(input.toLowerCase()) === 0);
};


function JumanjiLetterHint(element, offset) {
  this.constructor = JumanjiHint;
  this.constructor(element, offset);
}

function JumanjiNumberHint(element, offset) {
  this.constructor = JumanjiHint;
  this.constructor(element, offset);
}

function click_element(e) {
  var mouseEvent = document.createEvent("MouseEvent");
  mouseEvent.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
  e.element.dispatchEvent(mouseEvent);
  clear();
}
function create_stylesheet() {
  if (styles)
    return;
  styles = document.createElement("style");
  styles.type = "text/css";
  document.getElementsByTagName('head')[0].appendChild(styles);

  var style = document.styleSheets[document.styleSheets.length - 1];
  style.insertRule('*[jumanji_highlight=hint_normal] { background: ' + hint_normal_color + ' !important; } ', 0);
  style.insertRule('*[jumanji_highlight=hint_active] { background: ' + hint_active_color + ' !important } ', 0);
}

function get_visibility(e) {
  var style = document.defaultView.getComputedStyle(e, null);
  if (style.getPropertyValue("visibility") == "hidden" || style.getPropertyValue("display") == "none") {
      return false;
  }
  var rects = e.getClientRects()[0];
  var r = e.getBoundingClientRect();

  var height = window.innerHeight ? window.innerHeight : document.body.offsetHeight;
  var width = window.innerWidth ? window.innerWidth : document.body.offsetWidth;
  if (!r || r.top > height || r.bottom < 0 || r.left > width ||  r.right < 0 || !rects) {
    return false;
  }

  return true;
}

function get_element(e, offset, constructor) {
  var leftoff = 0;
  var topoff = 0;
  if (offset) {
    leftoff += offset[0];
    topoff += offset[1];
  }
  var off;
  if ( (e instanceof HTMLIFrameElement || e instanceof HTMLFrameElement) && e.contentDocument) {
    var res = e.contentDocument.body.querySelectorAll(hint_types);
    off = [ leftoff + e.offsetLeft, topoff + e.offsetTop ];
    for (var i=0; i < res.length; i++) {
      get_element(res[i], off, constructor);
    }
  }
  else {
    if (get_visibility(e)) {
      off = [ leftoff, topoff ];
      var element = new constructor(e, off);
      elements.push(element);
    }
  }
}

function show_hints() {
  document.activeElement.blur();

  var hints = document.createElement("div");
  hints.id = "jumanji_hints";
  var constructor = hint_style.toLowerCase() == "letter" ? JumanjiLetterHint : JumanjiNumberHint;

  create_stylesheet();

  var res = document.body.querySelectorAll(hint_types);
  var i = 0;
  for (i=0; i<res.length; i++) {
    get_element(res[i], null, constructor);
  }

  for (i=0; i<elements.length; i++) {
    if (res[i] == elements[i]) {
      continue;
    }
    var e = elements[i];
    hints.appendChild(e.hint);
    e.getTextHint(i, elements.length);
    e.element.setAttribute('jumanji_highlight', 'hint_normal');
  }
  active_arr = elements;
  document.body.appendChild(hints);
}

function update_hints(input) {
  var array = [];
  var text_content;
  var keep = false;
  if (input) {
    input = input.toLowerCase();
  }
  if (lastinput && (lastinput.length > input.length)) {
    clear();
    lastinput = input;
    show_hints();
    update_hints(input);
    return;
  }
  lastinput = input;
  for (var i=0; i<active_arr.length; i++) {
    var e = active_arr[i];
    if (e.matchText(input)) {
      array.push(e);
    }
    else {
      e.hint.style.visibility = 'hidden';
      e.element.removeAttribute('jumanji_highlight');
    }
  }
  active_arr = array;
  active = array[0];
  if (array.length === 0) {
    clear();
  } else if (array.length == 1) {
    return evaluate(array[0]);
  } else {
    lastpos = array[0].betterMatch(input);
    set_active(array[lastpos]);
  }
}

function set_active(element) {
  var active = document.querySelector('*[jumanji_highlight=hint_active]');
  if (active) {
    active.setAttribute('jumanji_highlight', 'hint_normal' );
  }
  element.element.setAttribute('jumanji_highlight', 'hint_active');
  active = element;
}

function clear() {
  if (elements) {
    for (var i=0; i<elements.length; i++) {
      elements[i].element.removeAttribute('jumanji_highlight');
    }
  }
  var hints = document.getElementById("jumanji_hints");
  if (hints)
    hints.parentNode.removeChild(hints);
  elements = [];
  active_arr = [];
}

function evaluate(element) {
  var ret;
  var e = element.element;
  var type = e.type.toLowerCase();
  var tagname = e.tagName.toLowerCase();

  if (tagname && (tagname == "input" || tagname == "textarea") ) {
    if (type == "radio" || type == "checkbox") {
      e.focus();
      click_element(element);
    }
    else if (type == "submit" || type == "reset" || type  == "button") {
      click_element(element);
    }
    else {
      e.focus();
    }
    clear();
  }
  else {
    ret = e.href;
  }
  return ret;
}

function get_active() {
  return evaluate(active);
}

function focus_next() {
  var newpos = lastpos == active_arr.length-1 ? 0 : lastpos + 1;
  active = active_arr[newpos];
  set_active(active);
  lastpos = newpos;
}

function focus_prev() {
  var newpos = lastpos === 0 ? active_arr.length-1 : lastpos - 1;
  active = active_arr[newpos];
  set_active(active);
  lastpos = newpos;
}
clear();
