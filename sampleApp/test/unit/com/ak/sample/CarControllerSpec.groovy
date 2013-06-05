package com.ak.sample

import spock.lang.Specification
import grails.test.mixin.TestFor
import grails.test.mixin.Mock

@Mock(Car)
@TestFor(CarController)
class CarControllerSpec extends Specification{


    def "List should use the specified max param"(){
        when:
            controller.list(new Integer(20))
        then:
            model.carInstanceList == []
            model.carInstanceTotal == 0
            view.endsWith('list')
    }
}

