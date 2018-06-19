# This step file is used with searchProperties.feature.
# On the Redfin website, this test will use the search bar
# to search for properties in Beverly Hills. In this search,
# three filters are applied and the test asserts that each
# property in the results match the criteria.

Given (/^I visit the Redfin website$/) do
	visit 'https://www.redfin.com'
end

When (/^I search for a home in "Beverly Hills"$/) do
	within(:xpath, './/div[@id="homepageTabContainer"]') do
		fill_in('search-box-input', :with => 'Beverly Hills')
		click_button('Search')
	end
end

And (/^I select the place "Beverly Hills, CA"$/) do
	within(:xpath, './/div[@class="resultsView"]') do
		page.find('a[href="/city/1669/CA/Beverly-Hills"]').click
	end
end

# Three filters are set:
# - Max price is $1.25M
# - Max # of bedrooms is 1
# - Must have at least 2 full bathrooms
And (/^I set the filters$/) do
	click_button('Filters')
	
	page.find(:xpath, './/span[contains(@class, "maxPrice")]').click
	page.find(:xpath, './/span[contains(@class, "maxPrice")]//div[contains(@class, "flyout")]//span[contains(.,"$1.25M")]').click
	
	page.find(:xpath, './/span[contains(@class, "maxBeds")]').click
	page.find(:xpath, './/span[contains(@class, "maxBeds")]//div[contains(@class, "flyout")]//span[contains(.,"1")]').click
	
	page.find(:xpath, './/span[contains(@class, "baths")]').click
	page.find(:xpath, './/span[contains(@class, "baths")]//div[contains(@class, "flyout")]//span[contains(.,"2+")]').click	
	sleep(5)
	expect(page).to have_selector(:xpath, '//span[contains(@class, "wideSidepaneFilterCount") and text() = "3"]')
	
	click_button('Apply Filters')
end

# After applying the filters, the test asserts the criteria is correct
# using the table view for the results. Columns 3, 4, & 5 refer to price,
# bedrooms, and baths respectively.
Then (/^the listings should match the criteria$/) do
	click_button('Table')
	page.all(:xpath, './/tbody[@class="tableList"]').each do |tr|
		next unless expect(tr.all('td')[3].text.gsub(/\D/,'').to_i).to be < 1250000
		next unless expect(tr.all('td')[4].text.to_i).to be == 1
		next unless expect(tr.all('td')[5].text.to_i).to be >= 2
	end
end