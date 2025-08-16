import { LightningElement } from 'lwc';

export default class CustomContactSearch extends LightningElement {
  displayInfo = {
    primaryField: 'Name',
    additionalFields: ['Title'],
  };

  filter = {
      criteria: [
          {
              fieldPath: 'Email',
              operator: 'ne',
              value: '',
          },
          {
              fieldPath: 'Name',
              operator: 'like',
              value: '%smith%',
          }
      ],
      filterLogic: '1 AND 2',
  };
}