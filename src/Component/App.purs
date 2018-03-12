module Component.App where

import Prelude
import Control.Monad.Aff (Aff)
import Data.Int (fromString)
import Data.Maybe (Maybe(..))
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Node.Encoding (Encoding(UTF8))
import Node.FS (FS)
import Node.FS.Aff (readTextFile, writeTextFile)

component :: forall e. H.Component HH.HTML Query Input Message (Aff (fs :: FS | e))
component =
  H.lifecycleComponent
    { receiver: const Nothing
    , initialState: const initialState
    , render
    , eval
    , initializer: Just (H.action Initialize)
    , finalizer: Nothing
    }

data Query a = Initialize a | Increment a

type Input = Unit

type Message = Void

type State = Maybe Int

initialState :: State
initialState = Nothing

render :: State -> H.ComponentHTML Query
render state =
  HH.button [ HE.onClick $ HE.input_ Increment ] [ HH.text $ show state ]

eval :: forall e. Query ~> H.ComponentDSL State Query Message (Aff (fs :: FS | e))
eval (Initialize next) = do
  state' <- H.liftAff $ readTextFile UTF8 "count.txt"
  let state = deserialize state'
  H.put state
  pure next
eval (Increment next) = do
  currentState <- H.get
  let nextState = increment currentState
  H.liftAff $ writeTextFile UTF8 "count.txt" $ serialize nextState
  H.put nextState
  pure next

increment :: State -> State
increment Nothing = Just 0
increment (Just n) = Just $ n + 1

serialize :: State -> String
serialize Nothing = ""
serialize (Just n) = show n

deserialize :: String -> State
deserialize "" = Nothing
deserialize s = fromString s
