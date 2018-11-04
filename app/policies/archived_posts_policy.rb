class ArchivedPostsPolicy < GroupBasePolicy
	def restore_all?
		archive?
	end

	def restore?
		restore_all?
	end
end