import { LightningElement, track } from 'lwc';

export default class TodoLists extends LightningElement {
    @track listOfTodo = new Array();
    @track newItem = '';
    @track itemNo = 1;
    @track showList = false;

    handleClick(event){

        console.log('newItem ',this.newItem);
        console.log('newItem 1',this.listOfTodo.indexOf(this.newItem));

        let containsItem = false;

        if(this.newItem){
            if(this.listOfTodo && this.listOfTodo.length > 0){
                for(let i=0;i<this.listOfTodo.length;i++){
                    console.log('condition ', this.listOfTodo[i].Name == this.newItem);
                    if(this.listOfTodo[i].Name == this.newItem){
                        containsItem = true;
                        break;
                    }
                }
            }

            console.log('newItem 2',containsItem);

            if(containsItem === false){
                this.showList = true;
                this.listOfTodo.push({id:this.itemNo,Name:this.newItem});
                this.itemNo = this.itemNo+1;
                this.newItem = '';
            }
            else{
                alert('Already present !!');
            }
        }
        else{
            alert('Task cannot be blank!!');
        }
        console.log('button clicked ',this.listOfTodo);
    }

    handleInputChange(event){
        console.log('event ',event.target);
        if(event.target.name == "listItem"){
            this.newItem = event.target.value;    
        }
        
    }

    handleRemove(event){
        let idOfRemovedItem = event.target.dataset.targetId;

        if(idOfRemovedItem && idOfRemovedItem > 0){
            this.listOfTodo = this.listOfTodo.filter((item) => {return item.id != idOfRemovedItem});

            if(this.listOfTodo.length == 0){
                this.showList = false;    
            }
        }

        console.log('id of removed element '+idOfRemovedItem);     
    }
}