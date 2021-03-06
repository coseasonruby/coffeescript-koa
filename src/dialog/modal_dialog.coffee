## -------------------------------------------------------------------------------------------------------------
##
class ModalDialog

	# @property [String] content the content of the modal defualt is Default Content
	content:      "Default content"

	# @property [String] title the title of the modal dialog default is Default Title
	title:        "Default title"

	# @property [String] ok the content to show on the ok button default is Ok
	ok:           "Ok"

	# @property [String] close the content to show on the close button default is close
	close:        "Close"

	# @property [Boolean] showFooter if the footer should be shown or not
	showFooter:   true

	# @property [Boolean] showOnCreate if the modal should be shown after created automatically
	showOnCreate: true

	# @property [String] position the position of the modal to display default is top
	position:     'top'

	# @property [FormWrapper|null] formWrapper formWrapper to display inside the modal
	formWrapper:  null

	## -------------------------------------------------------------------------------------------------------------
	## function to make the formDialog
	##
	makeFormDialog: () =>

		@close = "Cancel"

	## -------------------------------------------------------------------------------------------------------------
	## function to get the form object as formWrapper
	##
	## @return [FormWrapper] formWrapper
	##
	getForm: () =>

		if !@formWrapper? or !@formWrapper
			@formWrapper = new FormWrapper()

		return @formWrapper

	## -------------------------------------------------------------------------------------------------------------
	## constructor
	##
	## @param [Object] options any valid property can be used inside object
	##
	constructor:  (options) ->

		@gid = GlobalValueManager.NextGlobalID()

		@template = Handlebars.compile '''
			<div class="modal" id="modal{{gid}}" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header bg-primary">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
							<h4 class="modal-title">{{title}}</h4>
						</div>
						<div class="modal-body">
							<p>
							{{{content}}}
							</p>
						</div>

						{{#if showFooter}}
						<div class="modal-footer">
							{{#if close}}
							<button class="btn btn-sm btn-default btn1" type="button" data-dismiss="modal">{{close}}</button>
							{{/if}}
							{{#if ok}}
							<button class="btn btn-sm btn-primary btn2" type="button" data-dismiss="modal"><i class="fa fa-check"></i> {{ok}}</button>
							{{/if}}
						</div>
						{{/if}}

					</div>
				</div>
			</div>
		'''


		##
		##  Possibly overwrite default options
		if typeof options == "object"
			for name, val of options
				this[name] = val
		@createModal()
		if @showOnCreate
			@show()

	## --gao
	## function to create Modal Dialog based on Widget
	##
	createModal: ()=>
		@modalContainer = new WidgetTag "div", "modal", "modal#{@gid}", 
			"tabindex" 		: 	"-1"
			"role" 			: 	"dialog"
			"aria-hidden" 	: 	"true"
		@modalContainer.css "display", "none"
		@modalWrapper = @modalContainer.addDiv("modal-dialog").addDiv("modal-content")
		@header = @modalWrapper.addDiv "modal-header bg-primary"
		@buttonInHeader = @header.add "button", "close", "button-#{@gid}", 
			"data-dismiss" : 	"modal"
			"aria-label"   :	"Close"
		@spanInButton = @buttonInHeader.add("span", "", "", {"aria-hidden": "true"}).getTag().html '&times;'
		@header.add("h4", "modal-title").text("#{@title}")
		@body = @modalWrapper.addDiv "modal-body"
		@contentWrapper = @body.add("p")
		@contentWrapper.text "#{@content}"
		@viewContainer = @getBody().addDiv "modal-view", "modal-view#{@gid}"
		if @showFooter
			@footer = @modalWrapper.addDiv "modal-footer"
			if @close
				@button1 = @footer.add "button", "btn btn-sm btn-default btn1", "button1-#{@gid}", 
					"type" 			:	"button"
					"data-dismiss" 	: 	"modal"
				.text "#{@close}"
			if @ok
				@button2 = @footer.add "button", "btn btn-sm btn-default btn2", "button2-#{@gid}", 
					"type" 			:	"button"
					"data-dismiss" 	: 	"modal"
				@button2.add "i", "fa fa-check"
				@button2.add("span").text " #{@ok}"

	## -------------------------------------------------------------------------------------------------------------
	## function to execute on the close of the modal
	##
	## @event onClose
	## @return [Boolean]
	##
	onClose: () =>
		true

	## -------------------------------------------------------------------------------------------------------------
	## function to execute on the click of button1
	##
	## @event onButton1
	## @return [Boolean]
	##
	onButton1: () =>
		console.log "Default on button 1"
		@hide();
		true

	## -------------------------------------------------------------------------------------------------------------
	## function to execute on the click of button2
	##
	## @event onButton2
	## @return [Boolean]
	##
	onButton2: (e) =>
		if @formWrapper?
			@formWrapper.onSubmitAction(e)
		else
			console.log "Default on button 2"

		@hide();
		true

	## -------------------------------------------------------------------------------------------------------------
	## function to hide the modal
	##
	##
	hide: () =>
		@modal.modal('hide')

	## --gao
	## function to get modal body
	##
	getBody: ()=>
		@body

	## --gao
	## functioin to get container for view
	##
	getViewContainer: ()=>
		@viewContainer
	## -------------------------------------------------------------------------------------------------------------
	## function to show the modal
	##
	## @param [Object] options options to be used in showing the modal
	## @return [Boolean]
	##
	show: (options) =>

#		if @formWrapper?
#			@content += @formWrapper.getContent()

		#html = @template(this)

		$("body").append @modalContainer.getTag()

		@modal = $("#modal#{@gid}")

		@modal_body = @modal.find(".modal-body")
		if @formWrapper?		
			@viewContainer.append @formWrapper.getContent()
			@formWrapper.show()

		@modal.modal(options)
		@modal.on "hidden.bs.modal", () =>
			##|
			##|  Remove HTML from body
			@modal.remove()

			##|
			##|  Call the close event
			@onClose()

		@modal.find(".btn1").bind "click", () =>
			@onButton1()

		@modal.find(".btn2").bind "click", (e) =>
			e.preventDefault()
			e.stopPropagation()

			options = {}
			@modal.find("input,select").each (idx, el) =>
				#name = $(el).attr("name")
				id = $(el).attr("id")
				val  = $(el).val()
				options[id] = val

			if @onButton2(e, options) == true
				@onClose()

			true

		##|
		##| -------------------------------- Position of the dialog ---------------------------

		if @position == "center"

			@modal.css
				'margin-top' : () =>
					Math.max(0, ($(window).scrollTop() + ($(window).height() - @modal.height()) / 2 ))
