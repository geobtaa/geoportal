console.log('Vite ⚡️ Rails - GBL Admin')

// Import Stimulus and controllers
import { Application } from '@hotwired/stimulus'
import ResultsController from "./controllers/results_controller"

// Initialize Stimulus
window.Stimulus = Application.start()

// Register controllers
Stimulus.register("results", ResultsController)

// Import channels
import './channels';