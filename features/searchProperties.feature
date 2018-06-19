Feature: Search for properties with filters and confirm results
Scenario: A
	Given I visit the Redfin website
	When I search for a home in "Beverly Hills"
		And I select the place "Beverly Hills, CA"
		And I set the filters
	Then the listings should match the criteria