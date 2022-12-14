
import { css, html, LitElement } from 'lit-element';


// Allowed templates below
class NativeElement extends LitElement {

  render(){
    return html`
      <button @click="${this.handleClick}">Native </button>
    `;
  }

  handleClick(e) {
    console.log('--in native--');
    _superapp.callphone();
  }
}

class SimpleElement extends LitElement {
  static get properties() {
    return { data: { type: String } };
  }

  constructor() {
    super();
    this.id = '';
    this.data = 'NoTHING CHANGE';
  }

  static get styles() {
    return css`
      div { background-color: light-gray; }
      * { color: blue; }
  `}

  render(){
    return html`
      <button @click="${this.handleClick}">Simple Element ne</button>
      <div>Response:${this.data}</div>
    `;
  }

  handleClick(e) {
    console.log('--in simple--');
    _superapp.mySDKFunc({target: this, callbackFnName: 'callback'});
  }

  callback(msg) {
    this.data = msg;
  }
}

class SimpleElement2 extends LitElement {
  static get properties() {
    return { data: { type: String } };
  }

  constructor() {
    super();
    this.id = '';
    this.data = 'NoTHING CHANGE';
  }

  static get styles() {
    return css`
      div { background-color: light-gray; }
      * { color: blue; }
  `}

  render(){
    return html`
      <button @click="${this.handleClick}">Simple Element 2 ne</button>
      <div>Response:${this.data}</div>
    `;
  }

  handleClick(e) {
    console.log('--in simple--');
    _superapp.mySDKFunc2({target: this, callbackFnName: 'callback'});
  }

  callback(msg) {
    this.data = msg;
  }
}

customElements.define('native-element', NativeElement);
customElements.define('simple-element', SimpleElement);
customElements.define('simple-element2', SimpleElement2);


/* Core lib that should allow native functionality and callbacks */


// Observer pattern
document._observer = {
  listeners: [],
  registerListener: function(callback) {
    this.listeners.push(callback);
  },
  notify: function(msg) {``
    this.listeners.forEach(cb => cb.target[cb.callbackFnName](msg));
    this.listeners = [];
  }
};


var _superapp = {
  callphone: function() {
    SUPA.postMessage('phoneCall');
  },

  mySDKFunc: function(callback) {
    document._observer.registerListener(callback);
    SUPA.postMessage('onMyFunc');
  },

  mySDKFunc2: function(callback) {
    document._observer.registerListener(callback);
    SUPA.postMessage('onMyFunc2')
  },
};
