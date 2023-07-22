# Installing

Installing this expansions requires you to change the `configs.json` under the `config` folder of your EDOPro installation.

First, make a backup for the file in case something goes wrong. Now you can open the file with a text editor (Notepad will do the job).

Now paste this on the end of the `repos` array.

```json
,{
	"url": "https://github.com/NiiMiyo/EDOPro-4Fun-Supports",
	"repo_name": "Nii Miyo - 4Fun Supports",
	"should_update": true,
}
```

It should be now something like this:

```json
{
	"repos": [
		// Some stuff similar to what you are pasting. DO NOT REMOVE IT.
		,{
			"url": "https://github.com/NiiMiyo/EDOPro-4Fun-Supports",
			"repo_name": "Nii Miyo - 4Fun Supports",
			"should_update": true,
		}
	],
	// Some other stuff
}
```

Now open your game and the cards should be there.

If some error occurs, check if:
- you didn't edit the backup by mistake.
- you didn't delete something from the file by mistake.
- there is already a comma `(,)` before the one you paste (at the start of the first line), if that is the case, delete any one of them so it has only one.

If it still doesn't work, try using a JSON Validator Tool online to identify the problem.
