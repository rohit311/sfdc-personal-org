import { LightningElement, track } from 'lwc';

export default class ForEachDirectiveDemo extends LightningElement {

    @track cities = [
        {
            Id: 1,
            Name: 'Hyderabad',
        },
        {
            Id: 2,
            Name: 'Noida',
        },
        {
            Id: 3,
            Name: 'Pune',
        },
    ];

}