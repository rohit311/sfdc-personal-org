import { LightningElement , track} from 'lwc';

export default class ShowPostsComp extends LightningElement {
    
    @track responseData = new Array();

    renderedCallback(){
        fetch('https://jsonplaceholder.typicode.com/posts',{method:"GET"})
        .then((response) => {
            console.log(response);
            return response.json()})
        .then(responseJson => {
            this.responseData = responseJson;
            console.log('reponse ',this.responseData);
        })
        .catch(error => {console.log('error ',error)});
    }

}