import { LightningElement } from 'lwc';

export default class TreeDemo extends LightningElement {

  items = [
    {
      label: 'Western Sales Director',
      name: '1',
      expanded: true,
      items: [
          {
              label: 'Western Sales Manager',
              name: '2',
              expanded: true
      }
      ]
    }
  ];
}