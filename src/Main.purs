module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Halogen.Aff (HalogenEffects, awaitBody, runHalogenAff)
import Halogen.VDom.Driver (runUI)
import Node.FS (FS)
import Component.App as App

main :: forall e. Eff (HalogenEffects (fs :: FS | e)) Unit
main = runHalogenAff (awaitBody >>= runUI App.component unit)
