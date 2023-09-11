import { LightningElement } from 'lwc';

export default class WebSocketDemo extends LightningElement {

  dataFromWs = '';
  wsInstance;

  connectedCallback() {
    this.wsInstance = new WebSocket("wss://demo.piesocket.com/v3/channel_123?api_key=VCXCEuvhGcBDP7XhiJJUDvR1e1D3eiVjgZ9VRiaV&notify_self");

    this.wsInstance.addEventListener("open", () => {
      console.log("Connection opened");
    });

    this.wsInstance.addEventListener("message", (event) => {
      console.log("In message ", event.data);
      this.dataFromWs = event.data;
    });
  }

  disconnectedCallback() {
    this.wsInstance.close();
  }

  handleClick() {
    if(this.wsInstance) {
      this.wsInstance.send("Hi , From the client !");
    }
  }

}