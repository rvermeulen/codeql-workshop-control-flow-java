/**
 * @kind problem
 */

import java
import semmle.code.java.controlflow.Dominance
import semmle.code.java.controlflow.Paths

class InitActionConfiguration extends ActionConfiguration {
  InitActionConfiguration() { this = "InitActionConfiguration" }

  override predicate isAction(ControlFlowNode node) {
    // Replace with solution to exercise 7.
    none()
  }
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
  // Implement predicate to determine if the Call call dominates the ControlFlowNode node and always performs the initialization action
  // or if all the callers of the enclosing callable of the ControlFlowNode node are dominated by a call that always performs the initialization action.
  none()
}

from SomeActionAccess someActionAccess
// Add the solution from exercise 6 and
// add a condition that excludes calls that interprocedually dominate someAction method accesses and that always call the initialize method by reusing the dominatingCall predicate.
select someActionAccess, "Method $@ called without being preceded by initialize.", someActionAccess,
  someActionAccess.getMethod().getName()
