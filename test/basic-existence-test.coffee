mongoose = require 'mongoose'
chai = require 'chai'
should = chai.should()

describe 'WHEN loading the module', ->
  index = require '../src/index'

  it 'should exists', ->
    index.should.exist

describe 'WHEN we use camel case convention', ->
  convention = require '../src/index'
  schema = new mongoose.Schema
  schema.add {underscore_field: 'string'}
  schema.plugin convention

  it 'should add camelcase virtuals for underscored fields', ->
    schema.virtualpath('underscoreField').should.exist

  it 'added virtual fields should have getters', ->
    schema.virtualpath('underscoreField').getters.should.be.not.empty

  it 'added virtual fields should have setters', ->
    schema.virtualpath('underscoreField').setters.should.be.not.empty

  it 'should set value to underscored field over added virtual setter', ->
    document = new (mongoose.model 'Test', schema)
    document.underscoreField = value = 'value'
    document.underscore_field.should.be.equal value

  it 'should return value of underscore field over virtual getter', ->
    document = new (mongoose.model 'Test', schema)
    document.underscore_field = value = 'value'
    document.underscoreField.should.be.equal value

  it 'should not add virtuals for private fields by default', ->
    schema.add {_private_underscore_field: 'string'}
    schema.plugin convention
    should.not.exist schema.virtualpath('privateUnderscoreField')

  it 'should add virtuals for private fields according given options', ->
    schema.add {_private_underscore_field: 'string'}
    schema.plugin convention, { private: true }
    schema.virtualpath('privateUnderscoreField').should.exist