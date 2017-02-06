"Filed out from Dolphin Smalltalk 7"!

WeakArray variableSubclass: #WeakAnnouncementSubscription
	instanceVariableNames: 'announcer announcementClass action'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WeakAnnouncementSubscription guid: (GUID fromString: '{D0E41596-8781-40BB-97FB-9EA63E7E7698}')!
WeakAnnouncementSubscription comment: 'A WeakAnnouncementSubscription is a subscription which is removed automatically when the subscriber is unreferenced.
!WeakAnnouncementSubscription categoriesForClass!Announcements-Core! !
!WeakAnnouncementSubscription methodsFor!

action

action: anObject

announcementClass

announcementClass: anObject

announcer

announcer: anAnnouncer

deliver: anAnnouncement 
	"Deliver an announcement to receiver. In case of failure"

	^(self handlesAnnouncement: anAnnouncement) ifTrue: [action cull: anAnnouncement cull: announcer]!

handlesAnnouncement: anAnnouncement

makeStrong

makeWeak

subscriber

subscriber: anObject

valuable: aValuable
!WeakAnnouncementSubscription categoriesFor: #action!accessing!public! !
!WeakAnnouncementSubscription categoriesFor: #action:!accessing!public! !
!WeakAnnouncementSubscription categoriesFor: #announcementClass!accessing!public! !
!WeakAnnouncementSubscription categoriesFor: #announcementClass:!accessing!public! !
!WeakAnnouncementSubscription categoriesFor: #announcer!accessing!public! !
!WeakAnnouncementSubscription categoriesFor: #announcer:!accessing!public! !
!WeakAnnouncementSubscription categoriesFor: #deliver:!announcing!public! !
!WeakAnnouncementSubscription categoriesFor: #handlesAnnouncement:!error handling!public! !
!WeakAnnouncementSubscription categoriesFor: #makeStrong!converting!public! !
!WeakAnnouncementSubscription categoriesFor: #makeWeak!converting!public! !
!WeakAnnouncementSubscription categoriesFor: #subscriber!accessing!public! !
!WeakAnnouncementSubscription categoriesFor: #subscriber:!accessing!public! !
!WeakAnnouncementSubscription categoriesFor: #valuable:!accessing!public! !

!WeakAnnouncementSubscription class methodsFor!

new
	^super new: 1! !
!WeakAnnouncementSubscription class categoriesFor: #new!public! !
