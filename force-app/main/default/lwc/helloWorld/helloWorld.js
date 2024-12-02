import { LightningElement, track } from 'lwc';
import fetchProfiles from '@salesforce/apex/LightningProfileController.fetchProfiles';
import {NavigationMixin} from 'lightning/navigation';


export default class HelloWorld extends NavigationMixin(LightningElement) {
    @track greeting = 'World';
    MySimpleValue = "The label wraps to a second line, in which case the background on the line that appears below the value to align with the wrapped label is now white";
    MySimpleValue2 = "";
    columns = [
      {
        subHeading: "A",
        subText: ["1", "2"]
      },
      {
        subHeading: "B",
        subText: ["3", "4"]
      },
      {
        subHeading: "C",
        subText: ["5", "6"]
      },
      {
        subHeading: "D",
        subText: ["7", "8"]
      },
      {
        subHeading: "E",
        subText: ["7", "8"]
      }
    ];
    changeHandler(event) {
        this.greeting = event.target.value;
    }

    handleClick(event) {

      this.template.querySelector(`[data-id="${event.currentTarget.dataset.id}"]`).style.background = "blue";
    }

  showSpinner=false;
  submitDetails(event) {
    this.showSpinner = true;
    console.log('Spinner 1 ::' + this.showSpinner) //set to true
    //Operation for SAVE method called
    fetchProfiles()
    .then(result => {
      // do something with results
    })
    .catch(error => {
      // do something with error
    })
    .finally(()=> {
      this.showSpinner = false;
    })

    console.log('Spinner 2 ::' + this.showSpinner); //set to false
  }

  async init() {
    let promise = new Promise((resolve, reject) => {
        setTimeout(() => resolve("done!"), 1000)
      });

      let result = await promise; // wait until the promise resolves (*)

  }

  connectedCallback() {
    this.init();
  }


  value = 'inProgress';

    get options() {
        return [
            { label: 'New', value: 'new' },
            { label: 'In Progress', value: 'inProgress' },
            { label: 'Finished', value: 'finished' },
        ];
    }

    handleChange(event) {
        this.value = event.detail.value;
    }

    scrollCheck(event){
      console.log('Current value of the input: ' + event.target.scrollTop);
      console.log('Current value of the input: ' + event.target.scrollBottom);
    }

    renderedCallback() {
      var div= this.refs.myDiv;
      console.log(':div:',div)
      div.onscroll = this.scrollCheck;
    }
}