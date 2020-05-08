@api @event
Feature: Event content creation
  In order to have events on the site
  As an editor
  I need to be able to create and see event items

  @javascript
  Scenario: Length limited fields are truncating characters exceeding the configured limit.
    Given I am logged in as a user with the "create oe_publication content, access content, edit own oe_publication content, view published skos concept entities" permission
    When I visit "the Publication creation page"
    Then I should see the text "Content limited to 170 characters, remaining: 170" in the "title form element"
    And I should see the text "Content limited to 250 characters, remaining: 250" in the "summary form element"
    And I should see the text "Content limited to 170 characters, remaining: 170" in the "alternative title form element"
    When I fill in "Page title" with "My Publication"
    And I fill in "Content owner" with "Committee on Agriculture and Rural Development"
    And I fill in "Teaser" with "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin eu hendrerit lacus, vitae bibendum odio. Fusce orci purus, hendrerit a magna at nullam. Text to remove"
    And I fill in "Introduction" with "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas felis leo, lobortis non eros in, consequat tempor est. Praesent sit amet sem eleifend, cursus arcu ac, eleifend nunc. Integer et orci sagittis, volutpat felis sit amet, tincidunt amet. Text to remove"
    And I fill in "Subject" with "financing"
    And I fill in "Responsible department" with "European Patent Office"
    And I press "Save"
    # We assert that the extra characters are actually truncated from the end of the string.
    Then I should not see "The text to remove."

  @javascript
  Scenario: Fields on the event content creation forms should be grouped logically.
    Given I am logged in as a user with the "create oe_event content, access content, edit own oe_event content, view published skos concept entities, manage corporate content entities" permission
    When I visit "the Event creation page"

    # The text assertions are actually checking for fields.
    # Proper steps will be introduced in OPENEUROPA-2160.
    Then I should see the text "Type"
    And I should see the text "Page title"
    And I should see the text "Description summary"
    And I should see the text "Subject"
    And I should see the text "Start date"
    And I should see the text "End date"
    And I should see the text "Status"
    And I should see the text "Languages"
    And I should see the text "Event website"
    And I should see the text "Link type"

    # The registration group is collapsed by default.
    And I should see the text "Registration"
    And I should not see the text "Registration URL"
    And I should not see the text "Registration date"
    And I should not see the text "Entrance fee"
    And I should not see the text "Registration capacity"
    When I press "Registration"
    Then I should see the text "Registration URL"
    And I should see the text "Registration date"
    And I should see the text "Entrance fee"
    And I should see the text "Registration capacity"

     # The venue group is open by default.
    And I should see the text "Venue"
    And I should see the text "Name"
    And I should see the text "Capacity"
    And I should see the text "Room"
    And I should see the text "Country"

    # The online group is collapsed by default.
    And I should see the text "Online"
    And I should not see the text "Online type"
    And I should not see the text "Online time"
    And I should not see the text "Online description"
    And I should not see the text "Online link"
    When I press "Online"
    Then I should see the text "Online type"
    And I should see the text "Online time"
    And I should see the text "Online description"
    And I should see the text "Online link"

    # The organiser group is opened by default.
    And I should see the text "Organiser"
    And I should see the text "Organiser is internal"
    And the "Internal organiser field" is visible
    And I should not see the text "Organiser name"
    When I uncheck "Organiser is internal"
    Then I should see the text "Organiser name"
    And the "Internal organiser field" is not visible

    # The full description group is opened by default.
    And I should see the text "Full description"
    And I should see the text "Featured media"
    And I should see the text "Featured media legend"
    And I should see the text "Full text"

    # The full report group is collapsed by default.
    And I should see the text "Event report"
    And I should not see the text "Report text"
    And I should not see the text "Summary for report"
    When I press "Event report"
    Then I should see the text "Report text"
    And I should see the text "Summary for report"

    # Make sure that the Event contact field group contains expected fields.
    And I should see the text "Event contact"
    When I press "Add new contact"
    And I wait for AJAX to finish
    Then I should see "Name" in the "Event contact" region
    Then I should see "Country" in the "Event contact" region
    Then I should see "Email" in the "Event contact" region
    Then I should see "Phone number" in the "Event contact" region

    # The alternative titles and teaser group is open by default.
    And I should see the text "Alternative titles and teaser"
    And I should see the text "Alternative title"
    And I should see the text "Navigation title"
    And I should see the text "Teaser"

    # Metadata fields are visible
    And I should see the text "Content owner"
    And I should see the text "Responsible department"
    And I should see the text "Language"

  @javascript
  Scenario: Make sure that the selectboxes contains correct options.
    Given I am logged in as a user with the "create oe_event content, access content, edit own oe_event content, view published skos concept entities" permission
    When I visit "the Event creation page"
    Then I should have the following options for the "Status" select:
      | As planned         |
      | Cancelled          |
      | Rescheduled        |
      | Postponed          |
    When I press "Online"
    Then I should have the following options for the "Online type" select:
      | - None -   |
      | Facebook   |
      | Livestream |

  @javascript @av_portal
  Scenario: Creation of a Event content through the UI.
    Given I am logged in as a user with the "create oe_event content, access content, edit own oe_event content, view published skos concept entities, manage corporate content entities" permission
    # Create a "Media AV portal photo".
    And the following AV Portal photos:
      | url                                                         |
      | https://audiovisual.ec.europa.eu/en/photo/P-038924~2F00-15  |
      | https://audiovisual.ec.europa.eu/en/photo/P-039321~2F00-04  |
    # Create a "Event" content.
    When I visit "the Event creation page"
    Then I fill in "Type" with "Info days"
    And I fill in "Page title" with "My Event item"

    # Registration field group.
    When I press "Registration"
    Then I fill in "Registration URL" with "http://example.com"
    And I set "23-02-2019 02:30" as the "Start date" of "Registration date"
    And I set "23-02-2019 14:30" as the "End date" of "Registration date"
    And I fill in "Entrance fee" with "Free of charge"
    And I fill in "Registration capacity" with "100 seats"

    And I fill in "Description summary" with "Description summary text"
    And I fill in "Subject" with "EU financing"
    And I set "21-02-2019 02:15" as the "Start date" of "Event date"
    And I set "21-02-2019 14:15" as the "End date" of "Event date"
    # Venue reference by inline entity form.
    And I fill in "Name" with "Name of the venue"
    And I fill in "Capacity" with "Capacity of the venue"
    And I fill in "Room" with "Room of the venue"
    And I select "Belgium" from "Country"
    And I wait for AJAX to finish
    And I fill in "Street address" with "Rue belliard 28"
    And I fill in "Postal code" with "1000"
    And I fill in "City" with "Brussels"

    # Online field group.
    When I press "Online"
    Then I select "Facebook" from "Online type"
    And I set "22-02-2019 02:30" as the "Start date" of "Online time"
    And I set "22-02-2019 14:30" as the "End date" of "Online time"
    And I fill in "Online description" with "Online description text"
    And I fill in "URL" with "http://ec.europa.eu/2" in the "Online link" region
    And I fill in "Link text" with "Online link" in the "Online link" region

    And I select "As planned" from "Status"
    And I fill in "Languages" with "Hungarian"

    # Organiser field group.
    When I uncheck "Organiser is internal"
    Then I fill in "Organiser name" with "Organiser name"

    # Event website field group.
    And I fill in "URL" with "http://ec.europa.eu" in the "Website" region
    And I fill in "Link text" with "Website" in the "Website" region

    # Add a social media link
    And I fill in "URL" with "http://twitter.com" in the "Social media links" region
    And I fill in "Link text" with "Twitter" in the "Social media links" region
    And I select "Twitter" from "Link type"

    # Description field group.
    And I fill in "Use existing media" with "Euro with miniature figurines" in the "Description" region
    And I fill in "Featured media legend" with "Euro with miniature figurines"
    And I fill in "Full text" with "Full text paragraph"

    # Report field group.
    When I press "Event report"
    And I fill in "Report text" with "Report text paragraph"
    And I fill in "Summary for report" with "Report summary text"

    # Event contact field group.
    When I press "Add new contact"
    And I wait for AJAX to finish
    Then I fill in "Name" with "Name of the event contact" in the "Event contact" region
    And I select "Hungary" from "Country" in the "Event contact" region
    And I wait for AJAX to finish
    And I fill in "Street address" with "Back street 3" in the "Event contact" region
    And I fill in "Postal code" with "9000" in the "Event contact" region
    And I fill in "City" with "Budapest" in the "Event contact" region
    And I fill in "Email" with "test@example.com" in the "Event contact" region
    And I fill in "Phone number" with "0488779033" in the "Event contact" region
    And I fill in "URL" with "mailto:example@email.com" in the "Event contact social media links" region
    And I fill in "Link text" with "Email" in the "Event contact social media links" region

    And I fill in "Content owner" with "Committee on Agriculture and Rural Development"
    And I fill in "Responsible department" with "Audit Board of the European Communities"
    And I fill in "Teaser" with "Event teaser"
    When I press "Save"

    Then I should see "My Event item"
    And I should see "Full text paragraph"
    And I should see "Thu, 02/21/2019 - 02:15"
    And I should see "Thu, 02/21/2019 - 14:15"
    And I should see "Info days"
    And I should see "Hungarian"
    And I should see "As planned"
    And I should see the link "Website"
    And I should see the link "Twitter"
    And I should see "Facebook"
    And I should see "Online description text"
    And I should see "Fri, 02/22/2019 - 02:30"
    And I should see "Fri, 02/22/2019 - 14:30"
    And I should see the link "Online link"
    And I should see "Organiser name"
    And I should see "Description summary text"
    And I should see "Euro with miniature figurines"
    And I should see "Report summary text"
    And I should see "Report text paragraph"
    And I should see the link "http://example.com"
    And I should see "Open"
    And I should see "Sat, 02/23/2019 - 02:30"
    And I should see "Sat, 02/23/2019 - 14:30"
    And I should see "Free of charge"
    And I should see "100 seats"
    # Venue entity values.
    And I should see the text "Name of the venue"
    And I should see the text "Capacity of the venue"
    And I should see the text "Room of the venue"
    And I should see the text "Rue belliard 28"
    And I should see the text "1000 Brussels"
    And I should see the text "Belgium"
    # Event contact values.
    And I should see the text "Name of the event contact"
    And I should see the text "Back street 3"
    And I should see the text "Budapest"
    And I should see the text "9000"
    And I should see the text "Hungary"
    And I should see the text "test@example.com"
    And I should see the text "0488779033"
    And I should see the link "Email"

  @javascript @av_portal
  Scenario: As an editor when I create an Event node, the required fields are correctly marked when not filled in.
    Given I am logged in as a user with the "create oe_event content, access content, edit own oe_event content, view published skos concept entities" permission
    # Create a "Media AV portal photo".
    And the following AV Portal photos:
      | url                                                         |
      | https://audiovisual.ec.europa.eu/en/photo/P-038924~2F00-15  |

    # Create a "Event" content.
    When I visit "the Event creation page"
    And I fill in "Page title" with "My Event item"
    And I select "As planned" from "Status"
    And I fill in "Languages" with "Hungarian"
    And I fill in "Type" with "Info days"
    And I fill in "Subject" with "EU financing"
    And I fill in "Content owner" with "Committee on Agriculture and Rural Development"
    And I fill in "Responsible department" with "Audit Board of the European Communities"
    And I fill in "Teaser" with "Event teaser"
    And I press "Save"
    Then I should see the following error messages:
      | error messages                                                                                 |
      | You have to fill in at least one of the following fields: Internal organiser or Organiser name |
    # Make sure that errors related to the Organiser fields are fixed.
    When I check "Organiser is internal"
    And I fill in "Internal organiser" with "Audit Board of the European Communities"
    And I press "Save"
    Then I should see the following success messages:
      | success messages                      |
      | Event My Event item has been created. |

    # Make sure that only one organiser field value is stored depending on the "Organiser is internal" checkbox.
    When I click "Edit"
    And I uncheck "Organiser is internal"
    And I fill in "Organiser name" with "VALUE NOT TO STORE"
    And I check "Organiser is internal"
    And I press "Save"
    Then I should see the following success messages:
      | success messages                      |
      | Event My Event item has been updated. |
    And I should not see the text "Organiser name"
    And I should not see the text "VALUE NOT TO STORE"

    # Make sure that validation of the Online fields group works as expected.
    When I click "Edit"
    And I press "Online"
    And I select "Facebook" from "Online type"
    And I press "Save"
    Then I should see the following error messages:
      | error messages                       |
      | Online time field is required. |
      | Online link field is required.       |
    # Make sure that errors related to the Online fields are fixed.
    And I set "22-02-2019 02:30" as the "Start date" of "Online time"
    And I set "22-02-2019 14:30" as the "End date" of "Online time"
    And I fill in "Online description" with "Online description text"
    And I fill in "URL" with "http://ec.europa.eu/2" in the "Online link" region
    And I fill in "Link text" with "Online link" in the "Online link" region
    And I press "Save"
    Then I should see the following success messages:
      | success messages                      |
      | Event My Event item has been updated. |

    # Make sure that validation of the Description fields group works as expected.
    When I click "Edit"
    And I fill in "Full text" with "Full text paragraph"
    And I press "Save"
    Then I should see the following error messages:
      | error messages                           |
      | Featured media field is required.        |
      | Featured media legend field is required. |
      | Description summary field is required.   |
    # Make sure that errors related to the Description fields are fixed.
    When I fill in "Description summary" with "Description summary text"
    And I fill in "Use existing media" with "Euro with miniature figurines" in the "Description" region
    And I fill in "Featured media legend" with "Euro with miniature figurines"
    And I press "Save"
    Then I should see the following success messages:
      | success messages                      |
      | Event My Event item has been updated. |

    # Make sure that validation of the Registration fields group works as expected.
    When I click "Edit"
    And I press "Registration"
    And I set "23-02-2019 02:15" as the "Start date" of "Registration date"
    And I set "23-02-2019 14:15" as the "End date" of "Registration date"
    And I fill in "Registration capacity" with "100"
    And I press "Save"
    Then I should see the following error messages:
      | error messages                      |
      | Registration URL field is required. |
    # Make sure that errors related to the Registration fields are fixed.
    And I fill in "Registration URL" with "http://example.com"
    And I press "Save"
    Then I should see the following success messages:
      | success messages                      |
      | Event My Event item has been updated. |