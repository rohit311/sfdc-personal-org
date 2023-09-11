({
	doinit : function(component, event) {
      var self = this;  
	  google.charts.load('current', {'packages':['corechart']});        
      google.charts.setOnLoadCallback(function(){self.drawChart(component, event)});
        
        
	},
    drawChart : function(component, event) {
        var data = google.visualization.arrayToDataTable([
          ['Task', 'Hours per Day'],
          ['Work',     11],
          ['Eat',      2],
          ['Commute',  2],
          ['Watch TV', 2],
          ['Sleep',    7]
        ]);

        var options = {
          title: 'My Daily Activities'
        };

        var chart = new google.visualization.PieChart(document.getElementById('piechart'));

        chart.draw(data, options);
        
    }    
})