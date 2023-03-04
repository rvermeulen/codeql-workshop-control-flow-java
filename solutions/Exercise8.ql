/**
 * @kind problem
 */

import java
import semmle.code.java.controlflow.Dominance
import semmle.code.java.controlflow.Paths

class InitActionConfiguration extends ActionConfiguration {
  InitActionConfiguration() { this = "InitActionConfiguration" }

  override predicate isAction(ControlFlowNode node) { node instanceof InitializeAccess }
}

class SomeApiClass extends Class {
  SomeApiClass() { hasName("SomeApi") }
}

class InitializeAccess extends MethodAccess {
  Method initialize;

  InitializeAccess() {
    this.getMethod() = initialize and
    initialize.hasName("initialize") and
    initialize.getDeclaringType() instanceof SomeApiClass
  }
}

class SomeActionAccess extends MethodAccess {
  Method someAction;

  SomeActionAccess() {
    this.getMethod() = someAction and
    someAction.hasName("someAction") and
    someAction.getDeclaringType() instanceof SomeApiClass
  }
}

predicate precededByInitializationCall(Call call, ControlFlowNode node) {
  dominates(call, node) and any(InitActionConfiguration config).callAlwaysPerformsAction(call)
  or
  forex(Call caller | caller.getCallee() = node.getEnclosingCallable() | precededByInitializationCall(call, caller))
}

from SomeActionAccess someActionAccess
where
  not exists(InitializeAccess initializeAccess | dominates(initializeAccess, someActionAccess)) and
  not exists(Call call | precededByInitializationCall(call, someActionAccess))
select someActionAccess, "Method $@ called without being preceded by initialize.", someActionAccess,
  someActionAccess.getMethod().getName()
