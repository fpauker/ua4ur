#!/usr/bin/ruby
#require_relative '../lib/opcua/server'
require 'opcua/server'

Daemonite.new do

  server = OPCUA::Server.new
  server.add_namespace "https://centurio.work/ur10evva"

  mt = server.types.add_object_type(:MeasurementType).tap{ |t|
    t.add_variable :SollWertX
    t.add_variable :SollWertY
    t.add_variable :SollWertZ
  }
  tt = server.types.add_object_type(:ToolType).tap{ |t|
    t.add_variable :ToolNumber
    t.add_variable :DuploNumber
    t.add_variable :testValue1
    t.add_object(:Measurements, server.types.folder).tap{ |u|
      u.add_object :M, mt, OPCUA::OPTIONALPLACEHOLDER
    }
  }
  pt = server.types.add_object_type(:RobotType).tap{ |r|
    r.add_variable :ManufacturerName
    t.add_object(:Tools, server.types.folder).tap{ |u|
      u.add_object :Tool, tt, OPCUA::OPTIONALPLACEHOLDER
    }
  }

  tools = server.objects.instantiate(:KalimatC34, pt).find(:Tools)

  t1 = tools.instantiate(:Tool1,tt)
  t2 = tools.instantiate(:Tool2,tt)
  t3 = tools.instantiate(:Tool3,tt)

  tn = t1.find(:ToolNumber)

  measurments_t1 = t1.find(:Measurements)
  measurments_t1.instantiate(:M1,mt)
  measurments_t1.instantiate(:M2,mt)

  p tn.id

  run do
    sleep server.run
    tn.value = Time.now
  end
end.loop!
