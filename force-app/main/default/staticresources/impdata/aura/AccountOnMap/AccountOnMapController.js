({
    init: function (cmp, event, helper) {
        
       var action = cmp.get("c.fetchAccounts");
        var locs=[];
        action.setCallback(this, function(response,err){
            if(response)
            {
                var accountLocs = JSON.parse(response.getReturnValue() ); 
                if(accountLocs)
                {
                    console.log(accountLocs.length);
                    for(var i =0; i < 38; i++)
                    {
                      //  console.log('accountLocs[i].Office_City__c'  + accountLocs[i].Office_City__c);
                        locs.push({
                            location: {
                                City: accountLocs[i].Office_City__c,
                                Country: 'India',
                            },
                            
                            icon: 'custom:custom26',
                            title: accountLocs[i].Office_City__c
                        });
                    }    
                }
                else
                {
                    console.log('accountLocs'  + accountLocs);
                }
                
            }
            else{
                console.log(err);
            }
            
            if(locs){
                if(locs.length> 0 )
           			//cmp.set('v.mapMarkers', locs);     
                cmp.set('v.markersTitle', 'Indian Accounts');
            }
            
           
        });
        $A.enqueueAction(action);
        
        cmp.set("v.mapMarkers", [
    { location: {
        Country: 'Afghanistan',
        City: 'Kabul'
    }},
    { location: {
        Country: 'Albania',
        City: 'Tirana'
    }},
    { location: {
        Country: 'Algeria',
        City: 'Alger'
    }},
    { location: {
        Country: 'American Samoa',
        City: 'Fagatogo'
    }},
    { location: {
        Country: 'Andorra',
        City: 'Andorra la Vella'
    }},
    { location: {
        Country: 'Angola',
        City: 'Luanda'
    }},
    { location: {
        Country: 'Anguilla',
        City: 'The Valley'
    }},
    
    { location: {
        Country: 'Antigua and Barbuda',
        City: 'Saint John\'s'
    }},
    { location: {
        Country: 'Argentina',
        City: 'Buenos Aires'
    }},
    { location: {
        Country: 'Armenia',
        City: 'Yerevan'
    }},
    { location: {
        Country: 'Aruba',
        City: 'Oranjestad'
    }},
    { location: {
        Country: 'Australia',
        City: 'Canberra'
    }},
    { location: {
        Country: 'Austria',
        City: 'Wien'
    }},
    { location: {
        Country: 'Azerbaijan',
        City: 'Baku'
    }},
    { location: {
        Country: 'Bahamas',
        City: 'Nassau'
    }},
    { location: {
        Country: 'Bahrain',
        City: 'al-Manama'
    }},
    { location: {
        Country: 'Bangladesh',
        City: 'Dhaka'
    }},
    { location: {
        Country: 'Barbados',
        City: 'Bridgetown'
    }},
    { location: {
        Country: 'Belarus',
        City: 'Minsk'
    }},
    { location: {
        Country: 'Belgium',
        City: 'Bruxelles [Brussel]'
    }},
    { location: {
        Country: 'Belize',
        City: 'Belmopan'
    }},
    { location: {
        Country: 'Benin',
        City: 'Porto-Novo'
    }},
    { location: {
        Country: 'Bermuda',
        City: 'Hamilton'
    }},
    { location: {
        Country: 'Bhutan',
        City: 'Thimphu'
    }},
    { location: {
        Country: 'Bolivia',
        City: 'La Paz'
    }},
    { location: {
        Country: 'Bosnia and Herzegovina',
        City: 'Sarajevo'
    }},
    { location: {
        Country: 'Botswana',
        City: 'Gaborone'
    }},
    
    { location: {
        Country: 'Brazil',
        City: 'Brasília'
    }},
    
    { location: {
        Country: 'Brunei',
        City: 'Bandar Seri Begawan'
    }},
    { location: {
        Country: 'Bulgaria',
        City: 'Sofia'
    }},
    { location: {
        Country: 'Burkina Faso',
        City: 'Ouagadougou'
    }},
    { location: {
        Country: 'Burundi',
        City: 'Bujumbura'
    }},
    { location: {
        Country: 'Cambodia',
        City: 'Phnom Penh'
    }},
    { location: {
        Country: 'Cameroon',
        City: 'Yaound'
    }},
    { location: {
        Country: 'Canada',
        City: 'Ottawa'
    }},
    { location: {
        Country: 'Cape Verde',
        City: 'Praia'
    }},
    { location: {
        Country: 'Cayman Islands',
        City: 'George Town'
    }},
    { location: {
        Country: 'Central African Republic',
        City: 'Bangui'
    }},
    { location: {
        Country: 'Chad',
        City: 'N\'Djam'
    }},
    { location: {
        Country: 'Chile',
        City: 'Santiago de Chile'
    }},
    { location: {
        Country: 'China',
        City: 'Peking'
    }},
    { location: {
        Country: 'Christmas Island',
        City: 'Flying Fish Cove'
    }},
    { location: {
        Country: 'Cocos (Keeling) Islands',
        City: 'West Island'
    }},
    { location: {
        Country: 'Colombia',
        City: 'Santaf'
    }},
    { location: {
        Country: 'Comoros',
        City: 'Moroni'
    }},
    { location: {
        Country: 'Congo',
        City: 'Brazzaville'
    }},
    { location: {
        Country: 'Cook Islands',
        City: 'Avarua'
    }},
    { location: {
        Country: 'Costa Rica',
        City: 'San Jos'
    }},
    { location: {
        Country: 'Croatia',
        City: 'Zagreb'
    }},
    { location: {
        Country: 'Cuba',
        City: 'La Habana'
    }},
    { location: {
        Country: 'Cyprus',
        City: 'Nicosia'
    }},
    { location: {
        Country: 'Czech Republic',
        City: 'Praha'
    }},
    { location: {
        Country: 'Denmark',
        City: 'Copenhagen'
    }},
    { location: {
        Country: 'Djibouti',
        City: 'Djibouti'
    }},
    { location: {
        Country: 'Dominica',
        City: 'Roseau'
    }},
    { location: {
        Country: 'Dominican Republic',
        City: 'Santo Domingo de Guzm'
    }},
    { location: {
        Country: 'East Timor',
        City: 'Dili'
    }},
    { location: {
        Country: 'Ecuador',
        City: 'Quito'
    }},
    { location: {
        Country: 'Egypt',
        City: 'Cairo'
    }},
    { location: {
        Country: 'El Salvador',
        City: 'San Salvador'
    }},
    { location: {
        Country: 'England',
        City: 'London'
    }},
    { location: {
        Country: 'Equatorial Guinea',
        City: 'Malabo'
    }},
    { location: {
        Country: 'Eritrea',
        City: 'Asmara'
    }},
    { location: {
        Country: 'Estonia',
        City: 'Tallinn'
    }},
    { location: {
        Country: 'Ethiopia',
        City: 'Addis Abeba'
    }},
    { location: {
        Country: 'Falkland Islands',
        City: 'Stanley'
    }},
    { location: {
        Country: 'Faroe Islands',
        City: 'Tórshavn'
    }},
    { location: {
        Country: 'Fiji Islands',
        City: 'Suva'
    }},
    { location: {
        Country: 'Finland',
        City: 'Helsinki [Helsingfors]'
    }},
    { location: {
        Country: 'France',
        City: 'Paris'
    }},
    { location: {
        Country: 'French Guiana',
        City: 'Cayenne'
    }},
    { location: {
        Country: 'French Polynesia',
        City: 'Papeete'
    }},    
    { location: {
        Country: 'Gabon',
        City: 'Libreville'
    }},
    { location: {
        Country: 'Gambia',
        City: 'Banjul'
    }},
    { location: {
        Country: 'Georgia',
        City: 'Tbilisi'
    }},
    { location: {
        Country: 'Germany',
        City: 'Berlin'
    }},
    { location: {
        Country: 'Ghana',
        City: 'Accra'
    }},
    { location: {
        Country: 'Gibraltar',
        City: 'Gibraltar'
    }},
    { location: {
        Country: 'Greece',
        City: 'Athenai'
    }},
    { location: {
        Country: 'Greenland',
        City: 'Nuuk'
    }},
    { location: {
        Country: 'Grenada',
        City: 'Saint George\'s'
    }},
    { location: {
        Country: 'Guadeloupe',
        City: 'Basse-Terre'
    }},
    { location: {
        Country: 'Guam',
        City: 'Aga'
    }},
    { location: {
        Country: 'Guatemala',
        City: 'Ciudad de Guatemala'
    }},
    { location: {
        Country: 'Guinea',
        City: 'Conakry'
    }},
    { location: {
        Country: 'Guinea-Bissau',
        City: 'Bissau'
    }},
    { location: {
        Country: 'Guyana',
        City: 'Georgetown'
    }},
    { location: {
        Country: 'Haiti',
        City: 'Port-au-Prince'
    }},
    { location: {
        Country: 'Holy See (Vatican City State)',
        City: 'Citt'
    }},
    { location: {
        Country: 'Honduras',
        City: 'Tegucigalpa'
    }},
    { location: {
        Country: 'Hong Kong',
        City: 'Victoria'
    }},
    { location: {
        Country: 'Hungary',
        City: 'Budapest'
    }},
    { location: {
        Country: 'Iceland',
        City: 'Reykjav'
    }},
    { location: {
        Country: 'India',
        City: 'New Delhi'
    }},
    { location: {
        Country: 'Indonesia',
        City: 'Jakarta'
    }},
    { location: {
        Country: 'Iran',
        City: 'Tehran'
    }},
    { location: {
        Country: 'Iraq',
        City: 'Baghdad'
    }},
    { location: {
        Country: 'Ireland',
        City: 'Dublin'
    }},
    { location: {
        Country: 'Israel',
        City: 'Jerusalem'
    }},
    { location: {
        Country: 'Italy',
        City: 'Roma'
    }},
    { location: {
        Country: 'Ivory Coast',
        City: 'Yamoussoukro'
    }},
    { location: {
        Country: 'Jamaica',
        City: 'Kingston'
    }},
    { location: {
        Country: 'Japan',
        City: 'Tokyo'
    }},
    { location: {
        Country: 'Jordan',
        City: 'Amman'
    }},
    { location: {
        Country: 'Kazakstan',
        City: 'Astana'
    }},
    { location: {
        Country: 'Kenya',
        City: 'Nairobi'
    }},
    { location: {
        Country: 'Kiribati',
        City: 'Bairiki'
    }},
    { location: {
        Country: 'Kuwait',
        City: 'Kuwait'
    }},
    { location: {
        Country: 'Kyrgyzstan',
        City: 'Bishkek'
    }},
    { location: {
        Country: 'Laos',
        City: 'Vientiane'
    }},
    { location: {
        Country: 'Latvia',
        City: 'Riga'
    }},
    { location: {
        Country: 'Lebanon',
        City: 'Beirut'
    }},
    { location: {
        Country: 'Lesotho',
        City: 'Maseru'
    }},
    { location: {
        Country: 'Liberia',
        City: 'Monrovia'
    }},
    { location: {
        Country: 'Libyan Arab Jamahiriya',
        City: 'Tripoli'
    }},
    { location: {
        Country: 'Liechtenstein',
        City: 'Vaduz'
    }},
    { location: {
        Country: 'Lithuania',
        City: 'Vilnius'
    }},
    { location: {
        Country: 'Luxembourg',
        City: 'Luxembourg [Luxemburg/L'
    }},
    { location: {
        Country: 'Macao',
        City: 'Macao'
    }},
    { location: {
        Country: 'Macedonia',
        City: 'Skopje'
    }},
    { location: {
        Country: 'Madagascar',
        City: 'Antananarivo'
    }},
    { location: {
        Country: 'Malawi',
        City: 'Lilongwe'
    }},
    { location: {
        Country: 'Malaysia',
        City: 'Kuala Lumpur'
    }},
    { location: {
        Country: 'Maldives',
        City: 'Male'
    }},
    { location: {
        Country: 'Mali',
        City: 'Bamako'
    }},
    { location: {
        Country: 'Malta',
        City: 'Valletta'
    }},
    { location: {
        Country: 'Marshall Islands',
        City: 'Dalap-Uliga-Darrit'
    }},
    { location: {
        Country: 'Martinique',
        City: 'Fort-de-France'
    }},
    { location: {
        Country: 'Mauritania',
        City: 'Nouakchott'
    }},
    { location: {
        Country: 'Mauritius',
        City: 'Port-Louis'
    }},
    { location: {
        Country: 'Mayotte',
        City: 'Mamoutzou'
    }},
    { location: {
        Country: 'Mexico',
        City: 'Ciudad de M'
    }},
    { location: {
        Country: 'Micronesia, Federated States of',
        City: 'Palikir'
    }},
    { location: {
        Country: 'Moldova',
        City: 'Chisinau'
    }},
    { location: {
        Country: 'Monaco',
        City: 'Monaco-Ville'
    }},
    { location: {
        Country: 'Mongolia',
        City: 'Ulan Bator'
    }},
    { location: {
        Country: 'Montserrat',
        City: 'Plymouth'
    }},
    { location: {
        Country: 'Morocco',
        City: 'Rabat'
    }},
    { location: {
        Country: 'Mozambique',
        City: 'Maputo'
    }},
    { location: {
        Country: 'Myanmar',
        City: 'Rangoon (Yangon)'
    }},
    { location: {
        Country: 'Namibia',
        City: 'Windhoek'
    }},
    { location: {
        Country: 'Nauru',
        City: 'Yaren'
    }},
    { location: {
        Country: 'Nepal',
        City: 'Kathmandu'
    }},
    { location: {
        Country: 'Netherlands',
        City: 'Amsterdam'
    }},
    { location: {
        Country: 'Netherlands Antilles',
        City: 'Willemstad'
    }},
    { location: {
        Country: 'New Caledonia',
        City: 'Noum'
    }},
    { location: {
        Country: 'New Zealand',
        City: 'Wellington'
    }},
    { location: {
        Country: 'Nicaragua',
        City: 'Managua'
    }},
    { location: {
        Country: 'Niger',
        City: 'Niamey'
    }},
    { location: {
        Country: 'Nigeria',
        City: 'Abuja'
    }},
    { location: {
        Country: 'Niue',
        City: 'Alofi'
    }},
    { location: {
        Country: 'Norfolk Island',
        City: 'Kingston'
    }},
    { location: {
        Country: 'North Korea',
        City: 'Pyongyang'
    }},
    { location: {
        Country: 'Northern Ireland',
        City: 'Belfast'
    }},
    { location: {
        Country: 'Northern Mariana Islands',
        City: 'Garapan'
    }},
    { location: {
        Country: 'Norway',
        City: 'Oslo'
    }},
    { location: {
        Country: 'Oman',
        City: 'Masqat'
    }},
    { location: {
        Country: 'Pakistan',
        City: 'Islamabad'
    }},
    { location: {
        Country: 'Palau',
        City: 'Koror'
    }},
    { location: {
        Country: 'Palestine',
        City: 'Gaza'
    }},
    { location: {
        Country: 'Panama',
        City: 'Ciudad de Panam'
    }},
    { location: {
        Country: 'Papua New Guinea',
        City: 'Port Moresby'
    }},
    { location: {
        Country: 'Paraguay',
        City: 'Asunci'
    }},
    { location: {
        Country: 'Peru',
        City: 'Lima'
    }},
    { location: {
        Country: 'Philippines',
        City: 'Manila'
    }},
    { location: {
        Country: 'Pitcairn',
        City: 'Adamstown'
    }},
    { location: {
        Country: 'Poland',
        City: 'Warszawa'
    }},
    { location: {
        Country: 'Portugal',
        City: 'Lisboa'
    }},
    { location: {
        Country: 'Puerto Rico',
        City: 'San Juan'
    }},
    { location: {
        Country: 'Qatar',
        City: 'Doha'
    }},
    { location: {
        Country: 'Reunion',
        City: 'Saint-Denis'
    }},
    { location: {
        Country: 'Romania',
        City: 'Bucuresti'
    }},
    { location: {
        Country: 'Russian Federation',
        City: 'Moscow'
    }},
    { location: {
        Country: 'Rwanda',
        City: 'Kigali'
    }},
    { location: {
        Country: 'Saint Helena',
        City: 'Jamestown'
    }},
    { location: {
        Country: 'Saint Kitts and Nevis',
        City: 'Basseterre'
    }},
    { location: {
        Country: 'Saint Lucia',
        City: 'Castries'
    }},
    { location: {
        Country: 'Saint Pierre and Miquelon',
        City: 'Saint-Pierre'
    }},
    { location: {
        Country: 'Saint Vincent and the Grenadines',
        City: 'Kingstown'
    }},
    { location: {
        Country: 'Samoa',
        City: 'Apia'
    }},
    { location: {
        Country: 'San Marino',
        City: 'San Marino'
    }},
    { location: {
        Country: 'Sao Tome and Principe',
        City: 'S'
    }},
    { location: {
        Country: 'Saudi Arabia',
        City: 'Riyadh'
    }},
    { location: {
        Country: 'Scotland',
        City: 'Edinburgh'
    }},
    { location: {
        Country: 'Senegal',
        City: 'Dakar'
    }},
    { location: {
        Country: 'Seychelles',
        City: 'Victoria'
    }},
    { location: {
        Country: 'Sierra Leone',
        City: 'Freetown'
    }},
    { location: {
        Country: 'Singapore',
        City: 'Singapore'
    }},
    { location: {
        Country: 'Slovakia',
        City: 'Bratislava'
    }},
    { location: {
        Country: 'Slovenia',
        City: 'Ljubljana'
    }},
    { location: {
        Country: 'Solomon Islands',
        City: 'Honiara'
    }},
    { location: {
        Country: 'Somalia',
        City: 'Mogadishu'
    }},
    { location: {
        Country: 'South Africa',
        City: 'Pretoria'
    }},

    { location: {
        Country: 'South Korea',
        City: 'Seoul'
    }},
    { location: {
        Country: 'South Sudan',
        City: 'Juba'
    }},
    { location: {
        Country: 'Spain',
        City: 'Madrid'
    }},
    { location: {
        Country: 'Sudan',
        City: 'Khartum'
    }},
    { location: {
        Country: 'Suriname',
        City: 'Paramaribo'
    }},
    { location: {
        Country: 'Svalbard and Jan Mayen',
        City: 'Longyearbyen'
    }},
    { location: {
        Country: 'Swaziland',
        City: 'Mbabane'
    }},
    { location: {
        Country: 'Sweden',
        City: 'Stockholm'
    }},
    { location: {
        Country: 'Switzerland',
        City: 'Bern'
    }},
    { location: {
        Country: 'Syria',
        City: 'Damascus'
    }},
    { location: {
        Country: 'Tajikistan',
        City: 'Dushanbe'
    }},
    { location: {
        Country: 'Tanzania',
        City: 'Dodoma'
    }},
    { location: {
        Country: 'Thailand',
        City: 'Bangkok'
    }},
    { location: {
        Country: 'Togo',
        City: 'Lom'
    }},
    { location: {
        Country: 'Tokelau',
        City: 'Fakaofo'
    }},
    { location: {
        Country: 'Tonga',
        City: 'Nuku\'alofa'
    }},
    { location: {
        Country: 'Trinidad and Tobago',
        City: 'Port-of-Spain'
    }},
    { location: {
        Country: 'Tunisia',
        City: 'Tunis'
    }},
    { location: {
        Country: 'Turkey',
        City: 'Ankara'
    }},
    { location: {
        Country: 'Turkmenistan',
        City: 'Ashgabat'
    }},
    { location: {
        Country: 'Turks and Caicos Islands',
        City: 'Cockburn Town'
    }},
    { location: {
        Country: 'Tuvalu',
        City: 'Funafuti'
    }},
    { location: {
        Country: 'Uganda',
        City: 'Kampala'
    }},
    { location: {
        Country: 'Ukraine',
        City: 'Kyiv'
    }},
    { location: {
        Country: 'United Arab Emirates',
        City: 'Abu Dhabi'
    }},
    { location: {
        Country: 'United Kingdom',
        City: 'London'
    }},
    { location: {
        Country: 'United States',
        City: 'Washington'
    }},
    { location: {
        Country: 'Uruguay',
        City: 'Montevideo'
    }},
    { location: {
        Country: 'Uzbekistan',
        City: 'Toskent'
    }},
    { location: {
        Country: 'Vanuatu',
        City: 'Port-Vila'
    }},
    { location: {
        Country: 'Venezuela',
        City: 'Caracas'
    }},
    { location: {
        Country: 'Vietnam',
        City: 'Hanoi'
    }},
    { location: {
        Country: 'Virgin Islands, British',
        City: 'Road Town'
    }},
    { location: {
        Country: 'Virgin Islands, U.S.',
        City: 'Charlotte Amalie'
    }},
    { location: {
        Country: 'Wales',
        City: 'Cardiff'
    }},
    { location: {
        Country: 'Wallis and Futuna',
        City: 'Mata-Utu'
    }},
    { location: {
        Country: 'Western Sahara',
        City: 'El-Aai'
    }},
    { location: {
        Country: 'Yemen',
        City: 'Sanaa'
    }},
    { location: {
        Country: 'Yugoslavia',
        City: 'Beograd'
    }},
    { location: {
        Country: 'Zambia',
        City: 'Lusaka'
    }
    },
    { location: {
        Country: 'Zimbabwe',
        City: 'Harare'
    }}
]);
        
       /* cmp.set('v.mapMarkers', [
            {
                location: {
                    City: 'Cap-d\'Ail',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Cap-d\'Ail'
            },
            {
                location: {
                    City: 'Beaulieu-sur-Mer',
                    Country: 'France',
                },

                icon: 'custom:custom96',
                title: 'Beaulieu-sur-Mer'
            },
            {
                location: {
                    City: 'Saint-Jean-Cap-Ferrat',
                    Country: 'France',
                },

                title: 'Saint-Jean-Cap-Ferrat'
            },
            {
                location: {
                    City: 'Villefranche-sur-Mer',
                    Country: 'France',
                },

                icon: 'custom:custom92',
                title: 'Villefranche-sur-Mer'
            },
            {
                location: {
                    City: 'Antibes',
                    Country: 'France',
                },

                icon: 'custom:custom61',
                title: 'Antibes'
            },
            {
                location: {
                    City: 'Juan-les-Pins',
                    Country: 'France',
                },

                icon: 'custom:custom74',
                title: 'Juan-les-Pins'
            },
            {
                location: {
                    City: 'Cannes',
                    Country: 'France',
                },

                icon: 'custom:custom3',
                title: 'Cannes'
            },
            {
                location: {
                    City: 'Saint-Raphaël',
                    Country: 'France',
                },

                icon: 'custom:custom54',
                title: 'Saint-Raphaël'
            },
            {
                location: {
                    City: 'Fréjus',
                    Country: 'France',
                },

                icon: 'custom:custom88',
                title: 'Fréjus'
            },
            {
                location: {
                    City: 'Sainte-Maxime',
                    Country: 'France',
                },

                icon: 'custom:custom92',
                title: 'Sainte-Maxime'
            },
            {
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },
            {
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },
            {
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Geneva',
                    Country: 'Switzerland',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Saint-Tropez',
                    Country: 'France',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'Paris',
                    Country: 'Italy',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },{
                location: {
                    City: 'New york',
                    Country: 'USa',
                },

                icon: 'custom:custom26',
                title: 'USA'
            },{
                location: {
                    City: 'Scottland',
                    Country: 'England',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            },
            {
                location: {
                    City: 'Mumbai',
                    Country: 'India',
                },

                icon: 'custom:custom26',
                title: 'Saint-Tropez'
            }
        ]); */
        
    }
})