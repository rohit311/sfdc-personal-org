import { LightningElement, wire } from "lwc";
import startRequest from "@salesforce/apexContinuation/SampleContinuationClass.startRequest";
export default class ContinuationComponent extends LightningElement {
  imperativeContinuation = {};

  // Using wire service
  @wire(startRequest)
  wiredContinuation;

  get formattedWireResult() {
    return JSON.stringify(this.wiredContinuation);
  }

  // Imperative Call
  async callContinuation() {
    try {
      this.imperativeContinuation = await startRequest();
      this.error = undefined;
    } catch (error) {
      this.imperativeContinuation = undefined;
      this.error = error;
    }
  }

  get formattedImperativeResult() {
    return JSON.stringify(this.imperativeContinuation);
  }
}