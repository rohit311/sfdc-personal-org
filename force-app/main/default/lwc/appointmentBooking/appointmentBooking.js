import { LightningElement } from 'lwc';
import APPOINTMENT_OBJECT from '@salesforce/schema/Appointment__c';
import DOCTOR_NAME_FIELD from '@salesforce/schema/Appointment__c.Doctor_Name__c';
import PATIENT_NAME_FIELD from '@salesforce/schema/Appointment__c.Patient_Name__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class AppointmentBooking extends LightningElement {

  objectName = APPOINTMENT_OBJECT;
  appointmentFields = [DOCTOR_NAME_FIELD, PATIENT_NAME_FIELD];

  constructor() {
    super();
    console.log("In constructor");
  }

  handleAppointmentCreated() {
    console.log("Button Clicked!");
    this.showToast({
      title: "Appointment booked",
      message: "Appointment booked",
      variant: "success",
      mode: "dismissable"
    });
  }

  showToast({title, message, variant, mode}) {
    const evt = new ShowToastEvent({
      title,
      message,
      variant,
      mode
    });
    this.dispatchEvent(evt);
  }
}