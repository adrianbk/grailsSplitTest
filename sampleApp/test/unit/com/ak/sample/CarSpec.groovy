package com.ak.sample

import grails.test.mixin.TestFor
import spock.lang.Specification

/**
 * See the API for {@link grails.test.mixin.domain.DomainClassUnitTestMixin} for usage instructions
 */
@TestFor(Car)
class CarSpec extends Specification {

	def setup() {
	}

	def cleanup() {
	}

	void "test fo a valid car domain"() {
        given: "Valid car attributes"
            def car = new Car(currentOwner: 'me', make: 'ford', model: 'GTR', previousOwners: 2, yearOfManufacture: 2012 )
        when: "I validate the car"
            def result = car.validate()
        then: 'The result should be true'
            result
	}
}