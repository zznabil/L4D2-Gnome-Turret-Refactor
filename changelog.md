# Changelog: `backup.turret.nut` to `production.turret.nut`

This document details the evolution from the original `backup.turret.nut` to the final, optimized `production.turret.nut`.

The final version is architecturally identical to the original backup. All changes were surgical and confined to the turret's thinking logic to improve performance without altering its core functionality.

---

### **Summary of Key Changes:**

1.  **Optimized Think Loop:** The single most significant change was moving the turret's main logic loop from a `RegisterOnTickFunction` (which runs on every server frame) to a manually throttled timer. This dramatically reduces the script's CPU usage, as the logic now only runs approximately 4 times per second instead of 60+ times per second.
2.  **Stateful Target Management:** The turret is now "smarter." It remembers its current target. Instead of constantly scanning for new enemies on every execution, it now only scans for a new target if its current one is dead or out of sight. This eliminates thousands of redundant, expensive checks.
3.  **Centralized Logic:** The core logic was centralized into a single `Turret_Think` function, which is now cleanly throttled and contains the new stateful logic.

---

### **Detailed Technical Changes:**

#### 1. `CTurret` Class Enhancement

*   **Before:** The original `CTurret` class had no way to store its current target.
*   **After:** A new variable `m_hTarget` and a corresponding `SetTarget` function were added to the `CTurret` class. This allows each turret object to maintain its own state, which is crucial for preventing redundant target scanning.

```diff
--- backup.turret.nut
+++ production.turret.nut
class CTurret
{
    // ... (existing constructor and functions)

+    // -- PERFORMANCE OPTIMIZATION START --
+    // Added a target handle to the class to manage state.
+    function SetTarget(hTarget)
+    {
+        m_hTarget = hTarget;
+    }
+    m_hTarget = null;
+    // -- PERFORMANCE OPTIMIZATION END --

    m_iAmmo = 0;
    // ... (rest of the class)
}
```

#### 2. `Turret_Think` Function Refactoring

*   **Before:** The main logic was in a globally registered `Turret_Think` function that ran on every server tick. Inside this function, it would always perform a full scan for potential targets (`g_aPotentialTargets.clear()`, `Entities.FindByClassname`, etc.) for every active turret, regardless of whether it already had a target.
*   **After:** The `Turret_Think` function was heavily optimized with two key changes:
    1.  **Global Throttling:** A timer (`g_flNextGlobalThinkTime`) now ensures the entire function only runs at a set interval (`TURRET_THINK_INTERVAL = 0.25`), preventing it from executing on every frame.
    2.  **Conditional Target Scan:** The expensive target acquisition logic is now wrapped in a conditional check. It only runs if the turret's `m_hTarget` is invalid. If a valid target already exists, it skips the scan and proceeds directly to the much cheaper line-of-sight checks and firing logic.

```diff
--- backup.turret.nut
+++ production.turret.nut
+ // =================================================================
+ // == PERFORMANCE OPTIMIZATION BLOCK START
+ // =================================================================
+ // The original code used RegisterOnTickFunction, which is very expensive.
+ // This has been replaced with a throttled global timer to reduce CPU usage.
+ g_flNextGlobalThinkTime <- 0.0;
+ const TURRET_THINK_INTERVAL = 0.25; // Increased from every frame to 4 times/sec

function Turret_Think()
{
+    // This check throttles the entire function.
+    if (Time() < g_flNextGlobalThinkTime)
+    {
+        return;
+    }
+    g_flNextGlobalThinkTime = Time() + TURRET_THINK_INTERVAL;

     // ... (player weapon state checks remain the same)

     // Inside the loop for each turret:
     // ...
+        // -- New stateful logic --
+        local currentTarget = null;
+        if (turret.m_hTarget != null && turret.m_hTarget.IsValid() && turret.m_hTarget.GetHealth() > 0)
+        {
+            // Logic to validate the existing target
+        }
+
+        if (currentTarget == null) // Only find a new target if we don't have one
+        {
+            // Expensive target acquisition code is now here
+        }

         // Firing logic now uses the 'currentTarget' variable
-        tbl = GetNearestEntity(turret.m_hTracerEntity, turret.m_hMachineGun);
-        if (tbl["target"])
+        if (currentTarget)
         {
             // ... (firing logic)
         }
     // ...
}
+ // =================================================================
+ // == PERFORMANCE OPTIMIZATION BLOCK END
+ // =================================================================
```
