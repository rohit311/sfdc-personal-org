import { LightningElement, wire } from 'lwc';
import { gql, graphql } from 'lightning/uiGraphQLApi';

export default class ExampleGQL extends LightningElement {
  @wire(graphql, {
    query: gql`
        query AccountInfo {
            uiapi {
                query {
                    Account(where: { Name: { like: "United%" } }) @category(name: "recordQuery") {
                        edges {
                            node {
                                Name @category(name: "StringValue") {
                                    value
                                    displayValue
                                }
                            }
                        }
                    }
                }
            }
        }`
})
accList
}