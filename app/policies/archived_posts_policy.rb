class ArchivedPostsPolicy < GroupBasePolicy
	def restore_all?
		archive?
	end

	def restore?
		restore_all?
	end

	def delete_all?
		restore_all?
	end
end