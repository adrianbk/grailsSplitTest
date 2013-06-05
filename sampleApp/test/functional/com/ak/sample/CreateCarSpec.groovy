package com.ak.sample

import geb.spock.GebSpec
import com.ak.sample.pages.CreateCarPage

class CreateCarSpec extends GebSpec {

    def "The create car page appears with some input fields"(){
        when:
            to CreateCarPage
        then:
            at CreateCarPage
    }

}
